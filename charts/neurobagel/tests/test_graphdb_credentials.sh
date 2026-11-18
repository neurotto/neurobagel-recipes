#!/usr/bin/env bash
set -euo pipefail

chart_dir=$(cd -- "$(dirname -- "$0")/.." && pwd)
script="$chart_dir/files/scripts/graphdb_setup.sh"
temporary=$(mktemp -d)
trap 'rm -rf -- "$temporary"' EXIT
mkdir "$temporary/bin"
cat >"$temporary/bin/curl" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$REQUEST_LOG"
while (( $# )); do
    if [[ $1 == -d ]]; then
        printf '%s\0' "$2" >>"$PAYLOAD_LOG"
        shift
    fi
    shift
done
printf 'false'
STUB
chmod +x "$temporary/bin/curl"
export PATH="$temporary/bin:$PATH"
export REQUEST_LOG="$temporary/requests" PAYLOAD_LOG="$temporary/payloads"
export NB_GRAPH_DB=repositories/fixture NB_GRAPH_USERNAME=fixture NB_GRAPH_PASSWORD=fixture

for credential in admin username password; do
    admin=fixture
    export NB_GRAPH_USERNAME=fixture NB_GRAPH_PASSWORD=fixture
    case "$credential" in
        admin) admin=$'invalid\tadmin' ;;
        username) export NB_GRAPH_USERNAME=$'invalid\tuser' ;;
        password) export NB_GRAPH_PASSWORD=$'invalid\tpassword' ;;
    esac
    if (cd "$temporary" && bash "$script" "$admin") >"$temporary/output" 2>&1; then
        printf 'Expected invalid %s to stop GraphDB setup.\n' "$credential" >&2
        exit 1
    fi
    grep -q 'credentials may not contain control characters' "$temporary/output"
    [[ ! -e $REQUEST_LOG ]] || { echo 'Invalid credentials reached curl.' >&2; exit 1; }
done

export NB_GRAPH_USERNAME=fixture NB_GRAPH_PASSWORD='quote"and\slash'
(cd "$temporary" && bash "$script" 'admin"with\slash') >"$temporary/output" 2>&1
python3 - "$PAYLOAD_LOG" <<'PY'
import json
import sys

with open(sys.argv[1], 'rb') as handle:
    payloads = [json.loads(payload) for payload in handle.read().split(b'\0') if payload]
assert payloads[0] == {'password': 'admin"with\\slash'}, payloads
assert payloads[2] == {'username': 'fixture', 'password': 'quote"and\\slash'}, payloads
PY
echo 'GraphDB credential validation tests passed.'
