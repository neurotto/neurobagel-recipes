#!/bin/bash
set -Eeuo pipefail

NB_GRAPH_PORT=${NB_GRAPH_PORT:-7200}
NB_GRAPH_MEMORY=${NB_GRAPH_MEMORY:-2G}
SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

/opt/graphdb/dist/bin/graphdb -Dgraphdb.home=/opt/graphdb/home "-Xmx${NB_GRAPH_MEMORY}" &
GRAPHDB_PID=$!
trap 'kill "$GRAPHDB_PID" 2>/dev/null || true; wait "$GRAPHDB_PID" 2>/dev/null || true' EXIT

# If secrets files are empty (meaning passwords have not been set or password file paths are incorrect), error out and exit
if [[ ! -f /run/secrets/db_admin_password || ! -s /run/secrets/db_admin_password ]]; then
    echo -e "Error: NB_GRAPH_ADMIN_PASSWORD secret is missing or empty. Please ensure that {NB_GRAPH_SECRETS_PATH}/NB_GRAPH_ADMIN_PASSWORD.txt exists and is not empty.\nExiting."
    exit 1
fi

if [[ ! -f /run/secrets/db_user_password || ! -s /run/secrets/db_user_password ]]; then
    echo -e "Error: NB_GRAPH_PASSWORD secret is missing or empty. Please ensure that {NB_GRAPH_SECRETS_PATH}/NB_GRAPH_PASSWORD.txt exists and is not empty.\nExiting."
    exit 1
fi

# TODO revisit/test this also once we document how users can change (in addition to the data files being uploaded) the variables to set up a non-tester database after a first-time deployment
export NB_GRAPH_ADMIN_PASSWORD
NB_GRAPH_ADMIN_PASSWORD=$(< /run/secrets/db_admin_password)
export NB_GRAPH_PASSWORD
NB_GRAPH_PASSWORD=$(< /run/secrets/db_user_password)

# Wait for an authenticated repository-list response. An empty list means the
# first-time setup still needs to create the repository.
repo_response=""
for attempt in $(seq 1 180); do
    if repo_response=$(curl -fsS -u "${NB_GRAPH_USERNAME}:${NB_GRAPH_PASSWORD}" \
        "http://127.0.0.1:${NB_GRAPH_PORT}/rest/repositories") \
        && [[ "$repo_response" == \[* ]]; then
        break
    fi
    if (( attempt == 180 )); then
        echo "Error: GraphDB did not return an authenticated repository list before timeout." >&2
        exit 1
    fi
    sleep 2
done

if [[ "$repo_response" == "[]" ]]; then
    FIRST_TIME_SETUP="on"
else
    FIRST_TIME_SETUP="off"
fi

echo "First time setup: ${FIRST_TIME_SETUP}"

mkdir -p "${SCRIPT_DIR}/logs"
cd "$SCRIPT_DIR"

# Logic for main setup
main() {
    echo "Setting up a Neurobagel graph backend..."
    echo "(The GraphDB server is being accessed inside the GraphDB container at http://localhost:${NB_GRAPH_PORT}.)"

    if [ "${FIRST_TIME_SETUP}" = "on" ]; then
        echo "Setting up GraphDB server..."
        ./graphdb_setup.sh "${NB_GRAPH_ADMIN_PASSWORD}"
        echo "Finished server setup."
    else
        echo "GraphDB server already set up, skipping setup."
    fi

    echo "Adding datasets to the database..."
    ./add_data_to_graph.sh /data "localhost:${NB_GRAPH_PORT}" \
        "$NB_GRAPH_DB" "$NB_GRAPH_USERNAME" "$NB_GRAPH_PASSWORD" --no-clear-data
    echo "Finished adding datasets to databases."

    echo "Adding Neurobagel vocabulary to the database"
    ./add_data_to_graph.sh /usr/src/neurobagel/vocab "localhost:${NB_GRAPH_PORT}" \
        "$NB_GRAPH_DB" "$NB_GRAPH_USERNAME" "$NB_GRAPH_PASSWORD"
    echo "Finished adding the Neurobagel vocabulary to the database."

    echo "Finished setting up the Neurobagel graph backend."
}

main 2>&1 | tee -a "${SCRIPT_DIR}/logs/DEPLOY.log"

# We don't have jobcontrol here, so can't bring GraphDB back to foreground
# instead we'll wait
wait "$GRAPHDB_PID"
