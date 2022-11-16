#!/bin/bash
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
CLOUDFLARE_FILE_PATH=${PROJECT_DIR}/../nginx/cloudflare.conf
cat >${CLOUDFLARE_FILE_PATH} <<EOM
#Cloudflare

# - IPv4
EOM
for i in $(curl -s -L https://www.cloudflare.com/ips-v4); do
    echo "set_real_ip_from $i;" >>$CLOUDFLARE_FILE_PATH
done
cat >>${CLOUDFLARE_FILE_PATH} <<EOM

# - IPv6
EOM
for i in $(curl -s -L https://www.cloudflare.com/ips-v6); do
    echo "set_real_ip_from $i;" >>$CLOUDFLARE_FILE_PATH
done
cat >>${CLOUDFLARE_FILE_PATH} <<EOM

real_ip_header CF-Connecting-IP;
EOM
echo ${CLOUDFLARE_FILE_PATH}
docker exec -i nginx-proxy nginx -t && docker exec -i nginx-proxy nginx -s reload
