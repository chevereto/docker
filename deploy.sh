#!/usr/bin/env bash

set -e

NAMESPACE="$1"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_EMAIL="$2"
ADMIN_PASSWORD="$(openssl rand -base64 8)"

NAMESPACE=${NAMESPACE} make provision &&
    NAMESPACE=${NAMESPACE} \
        ADMIN_PASSWORD=${ADMIN_PASSWORD} \
        ADMIN_EMAIL=${ADMIN_EMAIL} \
        ADMIN_USER=${ADMIN_USER} make install

echo ""
echo "🚀 Deployment complete!"

NAMESPACE=${NAMESPACE} make feedback--url

echo "Login details"
echo "--"
echo "Email: ${ADMIN_EMAIL}"
echo "Password: ${ADMIN_PASSWORD}"
