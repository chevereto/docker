#!/usr/bin/env bash
set -e
DIR="/var/www"
WORKING_DIR="$DIR/html"
mkdir -p /chevereto && mkdir -p /chevereto/download && mkdir -p /chevereto/installer
cd /chevereto/download
curl -S -o installer.tar.gz -L "https://github.com/chevereto/installer/archive/${CHEVERETO_INSTALLER_TAG}.tar.gz"
tar -xvzf installer.tar.gz
mv -v installer-"${CHEVERETO_INSTALLER_TAG}"/* /chevereto/installer/
if [ -f "$WORKING_DIR/composer.json" ]; then
    echo "[SKIP] Installer provisioning"
else
    cd /chevereto/installer
    php installer.php -a download -s $CHEVERETO_SOFTWARE -t=$CHEVERETO_TAG -l=$CHEVERETO_LICENSE
    php installer.php -a extract -s $CHEVERETO_SOFTWARE -f chevereto-pkg-*.zip -p $WORKING_DIR
fi
mkdir -p $WORKING_DIR/app
touch $WORKING_DIR/app/settings.php
chown www-data: $WORKING_DIR -R
cd $WORKING_DIR
rm -rf .gitkeep
ls -la
