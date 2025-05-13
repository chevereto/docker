#!/usr/bin/env bash
set -e
while IFS= read -r ID; do
    echo "🆔 $ID"
    docker exec --user www-data $ID app/bin/cli -C cron || true
done <<<"$(docker ps | grep "chevereto:" | awk '{ print $1 }')"
