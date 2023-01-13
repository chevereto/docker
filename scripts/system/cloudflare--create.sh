#!/bin/bash
curl --request POST \
  --url https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer ${CLOUDFLARE_TOKEN}" \
  --data '{
    "content": "'"${CLOUDFLARE_A_NAME}"'",
    "name": "'"${HOSTNAME}"'",
    "type": "CNAME",
    "proxied": true,
    "ttl": 3600
  }' | jq -r '.result.id'
