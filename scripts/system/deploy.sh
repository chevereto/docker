#!/usr/bin/env bash
set -e
NAMESPACE="${NAMESPACE}"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_EMAIL="${ADMIN_EMAIL}"
ADMIN_PASSWORD="$(openssl rand -base64 8)"
if [ -z ${NAMESPACE} ]; then
    echo "[!] NAMESPACE is not set"
    exit 1
fi
if [ -z ${ADMIN_EMAIL} ]; then
    echo "[!] ADMIN_EMAIL is not set"
    exit 1
fi
if [ -z ${CLOUDFLARE_A_NAME} ]; then
    HOSTNAME="${DOMAIN}"
    echo "* CLOUDFLARE_A_NAME is not set, skipping DNS creation"
else
    HOSTNAME="${NAMESPACE}.${DOMAIN}"
fi
echo "* Using hostname ${HOSTNAME}"
make --no-print-directory feedback feedback--compose feedback--url NAMESPACE=${NAMESPACE}
make --no-print-directory namespace NAMESPACE=${NAMESPACE} HOSTNAME="${HOSTNAME}"
if [ -n "${CLOUDFLARE_A_NAME}" ]; then
    make --no-print-directory cloudflare--create NAMESPACE=${NAMESPACE}
fi
make --no-print-directory up-d NAMESPACE=${NAMESPACE}
make --no-print-directory install NAMESPACE=${NAMESPACE} ADMIN_USER=${ADMIN_USER} ADMIN_EMAIL=${ADMIN_EMAIL} ADMIN_PASSWORD=${ADMIN_PASSWORD}
echo ""
echo "[OK] Deployment complete!"
cat <<EOF
   _                             .-.
  / )  .-.    ___          __   (   )
 ( (  (   ) .'___)        (__'-._) (
  \ '._) (,'.'               '.     '-.
   '.      /  "\               '    -. '.
     )    /   \ \   .-.   ,'.   )  (  ',_)    _
   .'    (     \ \ (   \ . .' .'    )    .-. ( \\
  (  .''. '.    \ \|  .' .' ,',--, /    (   ) ) )
   \ \   ', :    \    .-'  ( (  ( (     _) (,' /
    \ \   : :    )  / _     ' .  \ \  ,'      /
  ,' ,'   : ;   /  /,' '.   /.'  / / ( (\    (
  '.'      "   (    .-'. \       ''   \_)\    \\
                \  |    \ \__             )    )
              ___\ |     \___;           /  , /
             /  ___)                    (  ( (
             '.'                         ) ;) ;
 Sigan bailando!                        (_/(_/
----------------------------------------------------
EOF
NAMESPACE=${NAMESPACE} make --no-print-directory feedback--url
echo "Login details"
echo "--"
echo "Email: ${ADMIN_EMAIL}"
echo "Password: ${ADMIN_PASSWORD}"
