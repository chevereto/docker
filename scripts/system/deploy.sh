#!/usr/bin/env bash

set -e

NAMESPACE="${NAMESPACE}"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_EMAIL="${ADMIN_EMAIL}"
ADMIN_PASSWORD="$(openssl rand -base64 8)"

NAMESPACE=${NAMESPACE} make --no-print-directory provision &&
    NAMESPACE=${NAMESPACE} \
        ADMIN_PASSWORD=${ADMIN_PASSWORD} \
        ADMIN_EMAIL=${ADMIN_EMAIL} \
        ADMIN_USER=${ADMIN_USER} make --no-print-directory install

echo ""
echo "🚀 Deployment complete!"

NAMESPACE=${NAMESPACE} make --no-print-directory feedback--url

echo "Login details"
echo "--"
echo "Email: ${ADMIN_EMAIL}"
echo "Password: ${ADMIN_PASSWORD}"
