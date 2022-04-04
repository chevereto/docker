FROM httpd:2.4

WORKDIR /var/www/html

RUN mkdir -p ./_assets ./images

RUN chown www-data: . -R && ls -la
COPY --chown=www-data chevereto/ .
