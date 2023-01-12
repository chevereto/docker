#!/usr/bin/env bash
set -e
DOWNLOAD_DIR=${PWD}"/.temp"
WORKING_DIR=${PWD}"/chevereto"
PACKAGE=${VERSION}
if [ -z ${LICENSE} ]; then
    echo -n "Chevereto V4 License key (if any): 🔑"
    read -s LICENSE
    echo ""
fi
API_DOWNLOAD="https://chevereto.com/api/download/"
echo " ..."
echo "* Downloading Chevereto"
rm -rf $DOWNLOAD_DIR $WORKING_DIR
mkdir -p $DOWNLOAD_DIR $WORKING_DIR
echo "* Downloading chevereto/v4 $PACKAGE package"
echo "> ${API_DOWNLOAD}${PACKAGE}"
cd $DOWNLOAD_DIR
curl -f -SOJL \
    -H "License: $LICENSE" \
    "${API_DOWNLOAD}${PACKAGE}"
ZIP_NAME=$(basename *.zip)
echo "* Extracting ${ZIP_NAME} package"
unzip -oq ${ZIP_NAME} -d $WORKING_DIR
rm -rf *.zip $DOWNLOAD_DIR
cd -
ls -lh $WORKING_DIR
if [[ ! $ZIP_NAME == chevereto_* ]]; then
    ZIP_NAME=chevereto_${ZIP_NAME/.zip/_abcd.zip}
fi
VERSION_PATCH=$(echo "${ZIP_NAME}" | grep -oE "chevereto_([0-9\.]+)" | awk '{ print $1 }')
VERSION_PATCH=${VERSION_PATCH#"chevereto_"}
VERSION="$VERSION_PATCH"
VERSION="${VERSION#[vV]}"
VERSION_MAJOR="${VERSION%%\.*}"
VERSION_MINOR="${VERSION#*.}"
VERSION_MINOR="${VERSION_MINOR%.*}"
VERSION_PATCH="${VERSION##*.}"
TAG_MAJOR=${VERSION_MAJOR}
TAG_MINOR=${VERSION_MAJOR}.${VERSION_MINOR}
TAG_PATCH=${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}
TAGS=(latest ${TAG_MAJOR} ${TAG_MINOR} ${TAG_PATCH})
if [ ! "${VERSION}" = "latest" ]; then
    unset TAGS[0]
fi
PRINT_TAGS=$(
    IFS=","
    echo "${TAGS[*]}"
)
echo "* Building image tags ${IMAGE_NAME}:{${PRINT_TAGS}}"
DOCKER_TAG_OPTIONS=
for tag in ${TAGS[@]}; do
    DOCKER_TAG_OPTIONS="${DOCKER_TAG_OPTIONS} -t ${IMAGE_NAME}:$tag"
done
exec "$@" ${DOCKER_TAG_OPTIONS}
