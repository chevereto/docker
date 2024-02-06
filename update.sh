#!/usr/bin/env bash

set -e

ENV_FILE="./.env"
NAMESPACE_DIRECTORY="./namespace/"

if [ -f "${ENV_FILE}" ]; then
    export $(cat ${ENV_FILE} | xargs)
fi

echo "🚧 Updating all websites"
echo ""

for file in "$NAMESPACE_DIRECTORY"*; do
    if [ -d "$file" ]; then
        continue
    fi
    NAMESPACE=$(basename "$file")
    NAMESPACE_FILE="${NAMESPACE_DIRECTORY}${NAMESPACE}"
    echo "Updating ${NAMESPACE} namespace"

    export $(cat ${NAMESPACE_FILE} | xargs)

    make down NAMESPACE=$NAMESPACE
    make up-d NAMESPACE=$NAMESPACE EDITION=${EDITION:-"pro"} ENCRYPTION_KEY=${ENCRYPTION_KEY}
    make exec NAMESPACE=$NAMESPACE COMMAND="app/bin/legacy -C update"

    echo "✔ Updated ${NAMESPACE}"
done

echo ""
echo "All websites updated!"
