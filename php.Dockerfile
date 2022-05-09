ARG PHP=8.1
FROM composer:latest as composer
FROM php:${PHP}-fpm
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libgd-dev \
    libzip-dev \
    zip \
    unzip \
    imagemagick libmagickwand-dev --no-install-recommends \
    && docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    --with-webp=/usr/include/ \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install -j$(nproc) exif gd pdo_mysql zip opcache bcmath \
    && pecl install imagick \
    && docker-php-ext-enable imagick opcache \
    && php -m

ARG VERSION=4.0
ARG SERVICING=docker

ENV CHEVERETO_SOFTWARE=chevereto \
    CHEVERETO_TAG=$VERSION \
    CHEVERETO_SERVICING=$SERVICING \
    CHEVERETO_LICENSE= \
    CHEVERETO_ASSET_STORAGE_ACCOUNT_ID= \
    CHEVERETO_ASSET_STORAGE_ACCOUNT_NAME= \
    CHEVERETO_ASSET_STORAGE_BUCKET= \
    CHEVERETO_ASSET_STORAGE_KEY= \
    CHEVERETO_ASSET_STORAGE_NAME=assets \
    CHEVERETO_ASSET_STORAGE_REGION= \
    CHEVERETO_ASSET_STORAGE_SECRET= \
    CHEVERETO_ASSET_STORAGE_SERVER= \
    CHEVERETO_ASSET_STORAGE_SERVICE= \
    CHEVERETO_ASSET_STORAGE_TYPE=local \
    CHEVERETO_ASSET_STORAGE_URL= \
    CHEVERETO_DB_DRIVER=mysql \
    CHEVERETO_DB_HOST=mariadb \
    CHEVERETO_DB_NAME=chevereto \
    CHEVERETO_DB_PASS=user_database_password \
    CHEVERETO_DB_PDO_ATTRS='[]' \
    CHEVERETO_DB_PORT=3306 \
    CHEVERETO_DB_TABLE_PREFIX=chv_ \
    CHEVERETO_DB_USER=chevereto \
    CHEVERETO_DEBUG_LEVEL=1 \
    CHEVERETO_ENABLE_HTACCESS_CHECK=0 \
    CHEVERETO_ENABLE_PHP_PAGES=0 \
    CHEVERETO_ERROR_LOG=/dev/stderr \
    CHEVERETO_HOSTNAME_PATH=/ \
    CHEVERETO_HOSTNAME=localhost \
    CHEVERETO_HTTPS=1 \
    CHEVERETO_IMAGE_FORMATS_AVAILABLE='["JPG","PNG","BMP","GIF","WEBP"]' \
    CHEVERETO_IMAGE_LIBRARY=imagick \
    CHEVERETO_MAX_EXECUTION_TIME=30 \
    CHEVERETO_MEMORY_LIMIT=512M \
    CHEVERETO_POST_MAX_SIZE=64M \
    CHEVERETO_SESSION_SAVE_HANDLER=files \
    CHEVERETO_SESSION_SAVE_PATH=/tmp \
    CHEVERETO_UPLOAD_MAX_FILESIZE=64M \
    CHEVERETO_USER_ALBUMS_LIST_LIMIT=

RUN set -eux; \
    { \
    echo "default_charset = UTF-8"; \
    echo "display_errors = Off"; \
    echo "error_log = \${CHEVERETO_ERROR_LOG}"; \
    echo "log_errors = On"; \
    echo "max_execution_time = \${CHEVERETO_MAX_EXECUTION_TIME}"; \
    echo "memory_limit = \${CHEVERETO_MEMORY_LIMIT}"; \
    echo "post_max_size = \${CHEVERETO_POST_MAX_SIZE}"; \
    echo "session.cookie_httponly = On"; \
    echo "session.save_handler = \${CHEVERETO_SESSION_SAVE_HANDLER}"; \
    echo "session.save_path = \${CHEVERETO_SESSION_SAVE_PATH}"; \
    echo "upload_max_filesize = \${CHEVERETO_UPLOAD_MAX_FILESIZE}"; \
    } > $PHP_INI_DIR/conf.d/php.ini

WORKDIR /var/www/html

RUN mkdir -p _assets images \
    importing/no-parse \
    importing/parse-albums \
    importing/parse-users

RUN chown www-data: . -R && ls -la

COPY --chown=www-data chevereto/ .
RUN composer install \
    --working-dir=app \
    --no-progress \
    --ignore-platform-reqs && \
    chown www-data: app -R
