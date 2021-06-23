FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libgd-dev \
    libzip-dev \
    zip \
    imagemagick libmagickwand-dev --no-install-recommends \
    && docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    --with-webp=/usr/include/ \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install -j$(nproc) exif gd pdo_mysql zip opcache \
    && pecl install imagick \
    && docker-php-ext-enable imagick opcache \
    && php -m  \
    && a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

ARG CHEVERETO_SOFTWARE=chevereto
ARG CHEVERETO_TAG=3.20.6
ARG CHEVERETO_INSTALLER_TAG=2.2.3
ARG CHEVERETO_SERVICING=docker
ARG CHEVERETO_LICENSE

ENV CHEVERETO_SOFTWARE=$CHEVERETO_SOFTWARE \
    CHEVERETO_TAG=$CHEVERETO_TAG \
    CHEVERETO_INSTALLER_TAG=$CHEVERETO_INSTALLER_TAG \
    CHEVERETO_SERVICING=$CHEVERETO_SERVICING \
    CHEVERETO_LICENSE=$CHEVERETO_LICENSE \
    CHEVERETO_DB_HOST=mariadb \
    CHEVERETO_DB_USER=chevereto \
    CHEVERETO_DB_PASS=user_database_password \
    CHEVERETO_DB_NAME=chevereto \
    CHEVERETO_DB_TABLE_PREFIX=chv_ \
    CHEVERETO_DB_PORT=3306 \
    CHEVERETO_DB_DRIVER=mysql \
    CHEVERETO_DB_PDO_ATTRS=[] \
    CHEVERETO_DEBUG_LEVEL=1 \
    CHEVERETO_DISABLE_PHP_PAGES=0 \
    CHEVERETO_ERROR_LOG= \
    CHEVERETO_IMAGE_FORMATS_AVAILABLE=JPG,PNG,BMP,GIF,WEBP \
    CHEVERETO_IMAGE_LIBRARY=imagick \
    CHEVERETO_HTTPS=1 \
    CHEVERETO_HOSTNAME=localhost \
    CHEVERETO_HOSTNAME_PATH=/ \
    CHEVERETO_SESSION_SAVE_HANDLER=files \
    CHEVERETO_SESSION_SAVE_PATH=/tmp \
    CHEVERETO_UPLOAD_MAX_FILESIZE=25M \
    CHEVERETO_POST_MAX_SIZE=25M \
    CHEVERETO_MAX_EXECUTION_TIME=30 \
    CHEVERETO_MEMORY_LIMIT=512M \
    CHEVERETO_ASSET_STORAGE_NAME=assets \
    CHEVERETO_ASSET_STORAGE_TYPE=local \
    CHEVERETO_ASSET_STORAGE_KEY= \
    CHEVERETO_ASSET_STORAGE_SECRET=/var/www/html/_assets/ \
    CHEVERETO_ASSET_STORAGE_BUCKET= \
    CHEVERETO_ASSET_STORAGE_URL= \
    CHEVERETO_ASSET_STORAGE_REGION= \
    CHEVERETO_ASSET_STORAGE_SERVER= \
    CHEVERETO_ASSET_STORAGE_SERVICE= \
    CHEVERETO_ASSET_STORAGE_ACCOUNT_ID= \
    CHEVERETO_ASSET_STORAGE_ACCOUNT_NAME= 

RUN set -eux; \
    { \
    echo "log_errors = On"; \
    echo "error_log = /dev/stderr"; \
    echo "upload_max_filesize = \${CHEVERETO_UPLOAD_MAX_FILESIZE}"; \
    echo "post_max_size = \${CHEVERETO_POST_MAX_SIZE}"; \
    echo "max_execution_time = \${CHEVERETO_MAX_EXECUTION_TIME}"; \
    echo "memory_limit = \${CHEVERETO_MEMORY_LIMIT}"; \
    } > $PHP_INI_DIR/conf.d/php.ini

RUN mkdir -p /var/www/html/importing && \
    mkdir -p /var/www/html/importing/no-parse && \
    mkdir -p /var/www/html/importing/parse-album && \
    mkdir -p /var/www/html/importing/parse-users

VOLUME /var/www/html/_assets
VOLUME /var/www/html/images
VOLUME /var/www/html/importing
VOLUME /var/www/html/importing/no-parse
VOLUME /var/www/html/importing/parse-albums
VOLUME /var/www/html/importing/parse-users

COPY --chown=www-data:www-data chevereto/ /var/www/html
COPY chevereto.sh /chevereto.sh
RUN chmod +x /chevereto.sh && /chevereto.sh