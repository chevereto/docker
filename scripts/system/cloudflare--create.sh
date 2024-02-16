#!/usr/bin/env bash
set -e
echo "* Creating ${HOSTNAME} CNAME record at CloudFlare"
CLOUDFLARE_IDENTIFIER=$(curl --request POST \
  --url https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer ${CLOUDFLARE_TOKEN}" \
  --data '{
    "content": "'"${CLOUDFLARE_A_NAME}"'",
    "name": "'"${HOSTNAME}"'",
    "type": "CNAME",
    "proxied": true,
    "ttl": 3600
  }' | jq -r '.result.id')
if [ "${CLOUDFLARE_IDENTIFIER}" == null ]; then
  echo "CloudFlare integration failure"
  exit 1
fi
echo "CLOUDFLARE_IDENTIFIER=${CLOUDFLARE_IDENTIFIER}" >>${NAMESPACE_FILE}
echo "[OK] Hostname created @ ${CLOUDFLARE_IDENTIFIER}"
