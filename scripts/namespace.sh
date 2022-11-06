#!/usr/bin/env bash
set -e
if [ -f "${NAMESPACE_FILE}" ]; then
    echo "[!] File ${NAMESPACE_FILE} already exists"
    exit 1
fi
if [ "${ENCRYPTION_KEY}" == "" ]; then
    ENCRYPTION_KEY=$(openssl rand -base64 32)
    echo '🔑 Using auto encryption key'
fi
cat >${NAMESPACE_FILE} <<EOM
HOSTNAME=${HOSTNAME}
ENCRYPTION_KEY=${ENCRYPTION_KEY}
EOM
echo ${NAMESPACE_FILE}
