#!/usr/bin/env bash
set -e
PACKAGE=/var/www/html/importing/importing.tar.gz
IMPORTING=/var/www/html/importing/
curl -S -o ${PACKAGE} -L "https://codeload.github.com/chevereto/demo-importing/tar.gz/refs/heads/main"
tar -xf ${PACKAGE} -C ${IMPORTING} &&
    rm -rf ${PACKAGE} &&
    rsync -a ${IMPORTING}demo-importing-main/ ${IMPORTING} &&
    rm -rf ${IMPORTING}demo-importing-main
chown www-data: ${IMPORTING} -R
