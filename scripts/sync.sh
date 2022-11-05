#!/usr/bin/env bash
set -e
SOURCE=/var/www/chevereto/
TARGET=/var/www/html/
EXCLUDE="\.git|\.DS_Store|\.well-known|\.vscode|\/app\/vendor|\/app\/env\.php|\/app\/importer\/jobs"
[ -d "${SOURCE}"app/vendor/ ] && rsync --mkpath -a "${SOURCE}"app/vendor/ "${TARGET}"app/vendor/
cp "${SOURCE}".gitignore "${TARGET}".gitignore
function sync() {
    rsync -r -I -og \
        --chown=www-data:www-data \
        --info=progress2 \
        --filter=':- .gitignore' \
        --exclude '.git' \
        --exclude '.well-known' \
        --delete \
        $SOURCE $TARGET
}
sync
