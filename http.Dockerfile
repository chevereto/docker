FROM httpd:2.4

WORKDIR /var/www/html

RUN mkdir -p ./_assets ./images

COPY --chown=www-data chevereto/ .

RUN chown www-data: . -R && ls -la
