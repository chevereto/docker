#!/usr/bin/env bash
set -e
DOWNLOAD_DIR=${PWD}"/.temp"
WORKING_DIR=${PWD}"/chevereto"
PACKAGE=${VERSION}"-lite"
API_DOWNLOAD="https://chevereto.com/api/download/"
echo "* Downloading Chevereto"
rm -rf $DOWNLOAD_DIR $WORKING_DIR
mkdir -p $DOWNLOAD_DIR
mkdir -p $WORKING_DIR
echo "* Downloading chevereto/v4 $PACKAGE package"
echo "> ${API_DOWNLOAD}${PACKAGE}"
cd $DOWNLOAD_DIR
curl -f -SOJL \
    -H "License: $LICENSE" \
    "${API_DOWNLOAD}${PACKAGE}"
echo "* Extracting package"
unzip -oq ${CHEVERETO_SOFTWARE}*.zip -d $WORKING_DIR
rm -rf *.zip $DOWNLOAD_DIR
cd -
ls -la
