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
set -eux
{
    echo "<?php"
    echo "\$settings = ["
    echo "  'asset_storage_account_id' => getenv('CHEVERETO_ASSET_STORAGE_ACCOUNT_ID'),"
    echo "  'asset_storage_account_name' => getenv('CHEVERETO_ASSET_STORAGE_ACCOUNT_NAME'),"
    echo "  'asset_storage_bucket' => getenv('CHEVERETO_ASSET_STORAGE_BUCKET'),"
    echo "  'asset_storage_key' => getenv('CHEVERETO_ASSET_STORAGE_KEY'),"
    echo "  'asset_storage_name' => getenv('CHEVERETO_ASSET_STORAGE_NAME'),"
    echo "  'asset_storage_region' => getenv('CHEVERETO_ASSET_STORAGE_REGION'),"
    echo "  'asset_storage_secret' => getenv('CHEVERETO_ASSET_STORAGE_SECRET'),"
    echo "  'asset_storage_server' => getenv('CHEVERETO_ASSET_STORAGE_SERVER'),"
    echo "  'asset_storage_service' => getenv('CHEVERETO_ASSET_STORAGE_SERVICE'),"
    echo "  'asset_storage_type' => getenv('CHEVERETO_ASSET_STORAGE_TYPE'),"
    echo "  'asset_storage_url' => getenv('CHEVERETO_ASSET_STORAGE_URL'),"
    echo "  'db_driver' => getenv('CHEVERETO_DB_DRIVER'),"
    echo "  'db_host' => getenv('CHEVERETO_DB_HOST'),"
    echo "  'db_name' => getenv('CHEVERETO_DB_NAME'),"
    echo "  'db_pass' => getenv('CHEVERETO_DB_PASS'),"
    echo "  'db_pdo_attrs' => getenv('CHEVERETO_DB_PDO_ATTRS'),"
    echo "  'db_port' => (int) getenv('CHEVERETO_DB_PORT'),"
    echo "  'db_table_prefix' => getenv('CHEVERETO_DB_TABLE_PREFIX'),"
    echo "  'db_user' => getenv('CHEVERETO_DB_USER'),"
    echo "  'debug_level' => (int) getenv('CHEVERETO_DEBUG_LEVEL'),"
    echo "  'disable_php_pages' => (bool) getenv('CHEVERETO_DISABLE_PHP_PAGES'),"
    echo "  'hostname_path' => getenv('CHEVERETO_HOSTNAME_PATH'),"
    echo "  'hostname' => getenv('CHEVERETO_HOSTNAME'),"
    echo "  'https' => (bool) getenv('CHEVERETO_HTTPS'),"
    echo "  'image_formats_available' => explode(',', getenv('CHEVERETO_IMAGE_FORMATS_AVAILABLE')),"
    echo "  'session.save_handler' => getenv('CHEVERETO_SESSION_SAVE_HANDLER'),"
    echo "  'session.save_path' => getenv('CHEVERETO_SESSION_SAVE_PATH'),"
    echo "];"
} >$WORKING_DIR/app/settings.php
chown www-data: $WORKING_DIR -R
cd $WORKING_DIR
rm -rf .gitkeep
ls -la
