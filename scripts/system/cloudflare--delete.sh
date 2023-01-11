#!/bin/bash
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
curl --request DELETE \
  --url https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records/${CLOUDFLARE_IDENTIFIER} \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer ${CLOUDFLARE_TOKEN}"
