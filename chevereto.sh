#!/usr/bin/env bash
set -e
DIR="/var/www"
WORKING_DIR="$DIR/html"
ls -la $WORKING_DIR
CHEVERETO_PACKAGE=$CHEVERETO_TAG"-lite"
CHEVERETO_API_DOWNLOAD="https://chevereto.com/api/download/"
chv_install() {
    rm -rf /chevereto/download
    echo "Making working dir /chevereto/download"
    mkdir -p /chevereto/download
    echo "cd /chevereto/download"
    cd /chevereto/download
    echo "* Downloading chevereto/v4 $CHEVERETO_PACKAGE package"
    curl -f -SOJL \
        -H "License: $CHEVERETO_LICENSE" \
        "${CHEVERETO_API_DOWNLOAD}${CHEVERETO_PACKAGE}"
    echo "* Extracting package"
    unzip -oq ${CHEVERETO_SOFTWARE}*.zip -d $WORKING_DIR
    echo "* Installing dependencies"
    composer install \
        --working-dir=$WORKING_DIR/app \
        --no-progress \
        --classmap-authoritative \
        --ignore-platform-reqs
}
if [ -f "$WORKING_DIR/app/composer.json" ]; then
    echo "[NOTICE] Sourcing app from ./chevereto"
else
    chv_install
fi
chown www-data: $WORKING_DIR -R
cd $WORKING_DIR
ls -la
