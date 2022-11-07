#!/usr/bin/env bash
set -e
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
CRON_FILE=/etc/cron.d/chevereto
cat >${CRON_FILE} <<EOM
* * * * * ${USER} ${PROJECT_DIR}/cron-run.sh
EOM
echo ${CRON_FILE}
