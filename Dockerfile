ARG PHP=8.2

FROM composer:2 AS composer

FROM php:${PHP}-apache-trixie AS builder

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libgd-dev \
    libzip-dev \
    libicu-dev \
    libmagickwand-dev \
    zip unzip \
    --no-install-recommends \
    && docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    --with-webp=/usr/include/ \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-configure ftp --with-openssl-dir=/usr \
    && docker-php-ext-configure exif \
    && docker-php-ext-install -j$(nproc) exif gd pdo_mysql zip opcache bcmath ftp intl \
    && pecl install imagick \
    && pecl install redis \
    && docker-php-ext-enable exif imagick opcache redis \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

FROM php:${PHP}-apache-trixie AS runtime

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

RUN apt-get update && apt-get install -y \
    libfreetype6 \
    libjpeg62-turbo \
    libpng16-16 \
    libwebp7 \
    libgd3 \
    libzip5 \
    libicu76 \
    rsync \
    inotify-tools \
    imagemagick \
    ffmpeg \
    exiftool \
    exiftran \
    --no-install-recommends \
    && a2enmod rewrite && a2enmod ssl && a2enmod socache_shmcb \
    && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
    && sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-available/000-default.conf \
    && chown -R www-data:www-data /var/run/apache2 /var/lock/apache2 /var/log/apache2 /var/www/html \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG VERSION=4.5
ARG SERVICING=docker

ENV CHEVERETO_ERROR_LOG=/dev/stderr \
    CHEVERETO_MAX_EXECUTION_TIME_SECONDS=30 \
    CHEVERETO_MAX_MEMORY_SIZE=1G \
    CHEVERETO_MAX_POST_SIZE=64M \
    CHEVERETO_MAX_UPLOAD_FILE_SIZE=64M \
    CHEVERETO_SERVICING=docker \
    CHEVERETO_SESSION_SAVE_HANDLER=files \
    CHEVERETO_SESSION_SAVE_PATH=/tmp

RUN printf "%s\n" \
    "default_charset = UTF-8" \
    "display_errors = Off" \
    "error_log = \${CHEVERETO_ERROR_LOG}" \
    "expose_php = Off" \
    "log_errors = On" \
    "max_execution_time = \${CHEVERETO_MAX_EXECUTION_TIME_SECONDS}" \
    "memory_limit = \${CHEVERETO_MAX_MEMORY_SIZE}" \
    "post_max_size = \${CHEVERETO_MAX_POST_SIZE}" \
    "session.cookie_httponly = On" \
    "session.save_handler = \${CHEVERETO_SESSION_SAVE_HANDLER}" \
    "session.save_path = \${CHEVERETO_SESSION_SAVE_PATH}" \
    "upload_max_filesize = \${CHEVERETO_MAX_UPLOAD_FILE_SIZE}" \
    > $PHP_INI_DIR/conf.d/php.ini

WORKDIR /var/www/html

COPY scripts/chevereto /var/scripts

RUN chmod +x \
    /var/scripts/demo-importing.sh \
    /var/scripts/logo.sh

RUN mkdir -p images/_assets \
    importing/no-parse \
    importing/parse-albums \
    importing/parse-users \
    && chown -R www-data:www-data /var/scripts /var/www/html

USER www-data

EXPOSE 8080
