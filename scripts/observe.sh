#!/usr/bin/env bash
set -e
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
. $SCRIPT_DIR/sync.sh
inotifywait \
    --event create \
    --event delete \
    --event modify \
    --event move \
    --format "%e %w%f" \
    --exclude $EXCLUDE \
    --monitor \
    --recursive \
    $SOURCE |
    while read CHANGED; do
        sync
    done
