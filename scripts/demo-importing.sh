#!/usr/bin/env bash
set -e
curl -S -o /var/www/html/importing/importing.tar.gz -L "https://codeload.github.com/chevereto/demo-importing/tar.gz/refs/heads/main"

tar -xf /var/www/html/importing/importing.tar.gz -C /var/www/html/importing/ &&
    rm -rf /var/www/html/importing/importing.tar.gz &&
    rsync -a /var/www/html/importing/demo-importing-main/ /var/www/html/importing/ &&
    rm -rf /var/www/html/importing/demo-importing-main

chown www-data: /var/www/html/importing/ -R
