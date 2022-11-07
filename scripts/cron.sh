#!/usr/bin/env bash
set -e
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cat >/etc/cron.d/chevereto <<EOM
* * * * * ${PROJECT_DIR}/cron-run.sh
EOM
