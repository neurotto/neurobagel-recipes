#!/usr/bin/env bash
set -euo pipefail

chart_dir=$(cd -- "$(dirname -- "$0")/.." && pwd)
script="$chart_dir/files/scripts/wait-for-metadata.sh"
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT

(
  sleep 1
  printf '{}\n' >"$temp_dir/datasets_metadata.json"
) &
writer=$!
sh "$script" "$temp_dir/datasets_metadata.json" 4
wait "$writer"

if output=$(sh "$script" "$temp_dir/missing.json" 2 2>&1); then
  echo "expected metadata wait to fail when the file is absent" >&2
  exit 1
fi
grep -q 'ERROR: .*missing.json was not created within 2 seconds' <<<"$output"

echo "Metadata wait tests passed."
