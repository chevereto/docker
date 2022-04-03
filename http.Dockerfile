FROM httpd:2.4

WORKDIR /var/www/html

RUN mkdir -p /var/www/html/_assets && \
    mkdir -p /var/www/html/images && \
    mkdir -p /var/www/html/importing/no-parse && \
    mkdir -p /var/www/html/importing/parse-albums && \
    mkdir -p /var/www/html/importing/parse-users

RUN chown www-data: . -R
COPY --chown=www-data chevereto/ .
