#!/bin/sh
set -eu

file=${1:-/data/datasets_metadata.json}
timeout=${2:-360}

case "$timeout" in
    ''|*[!0-9]*|0)
        echo "ERROR: metadata wait timeout must be a positive integer" >&2
        exit 2
        ;;
esac

elapsed=0
while [ ! -s "$file" ]; do
    if [ "$elapsed" -ge "$timeout" ]; then
        echo "ERROR: $file was not created within $timeout seconds" >&2
        exit 1
    fi
    sleep 2
    elapsed=$((elapsed + 2))
done
