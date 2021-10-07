#!/usr/bin/env bash
set -e
DIR="/var/www"
WORKING_DIR="$DIR/html"
CHEVERETO_INSTALLER_DOWNLOAD="https://github.com/chevereto/installer/releases/download/"
mkdir -p /chevereto && mkdir -p /chevereto/download
cd /chevereto/download
curl -SOJL "${CHEVERETO_INSTALLER_DOWNLOAD}${CHEVERETO_INSTALLER_TAG}/installer.php"
if [ -f "$WORKING_DIR/composer.json" ]; then
    echo "[SKIP] Installer provisioning"
else
    php installer.php -a download -t=$CHEVERETO_TAG -l=$CHEVERETO_LICENSE
    php installer.php -a extract -f chevereto-pkg-*.zip -p $WORKING_DIR
fi
mkdir -p $WORKING_DIR/app
touch $WORKING_DIR/app/settings.php
chown www-data: $WORKING_DIR -R
cd $WORKING_DIR
rm -rf .gitkeep
ls -la
