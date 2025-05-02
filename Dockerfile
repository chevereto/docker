ARG PHP=8.2
FROM composer:latest AS composer
FROM php:${PHP}-apache
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libgd-dev \
    libzip-dev \
    zip unzip \
    rsync \
    inotify-tools \
    imagemagick libmagickwand-dev --no-install-recommends \
    ffmpeg \
    exiftool \
    exiftran \
    && a2enmod rewrite && a2enmod ssl && a2enmod socache_shmcb \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-webp=/usr/include/ \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-configure ftp --with-openssl-dir=/usr \
    && docker-php-ext-configure exif \
    && docker-php-ext-install -j$(nproc) exif gd pdo_mysql zip opcache bcmath ftp intl \
    && pecl install imagick \
    && pecl install redis \
    && docker-php-ext-enable exif imagick opcache redis \
    && php -m \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG VERSION=4.3
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
    /var/scripts/logo.sh \
    /var/scripts/observe.sh \
    /var/scripts/sync.sh

RUN mkdir -p images/_assets \
    importing/no-parse \
    importing/parse-albums \
    importing/parse-users

COPY --chown=www-data chevereto/ .

RUN chown www-data: . -R && ls -la
