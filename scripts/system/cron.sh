#!/usr/bin/env bash
set -e
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
CRON_FILE=/etc/cron.d/chevereto
echo "* Creating ${CRON_FILE}"
cat >${CRON_FILE} <<EOM
* * * * * ${USER} ${PROJECT_DIR}/cron--run.sh >/dev/null 2>&1
45 2 * * * ${USER} ${PROJECT_DIR}/cloudflare.sh >/dev/null 2>&1
EOM
echo "[OK] Cron file created @ ${CRON_FILE}"
