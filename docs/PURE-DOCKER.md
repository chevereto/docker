# Pure Docker

## Build image

Image building is required for Chevereto **paid edition**. Run this from the root of this repo to build the container image:

```sh
VERSION=4.0 \
IMAGE_NAME=chevereto \
./scripts/system/chevereto.sh \
docker build . \
    --cache-from ghcr.io/chevereto/chevereto \
    --network host \
    -f Dockerfile
```

By running the above command you will generate the following tags:

* `chevereto:latest`
* `chevereto:4`
* `chevereto:4.0`
* `chevereto:4.0.6`

## Run (paid edition)

To run [chevereto.com](https://chevereto.com/features) (paid edition) you need to pass the environment targeting your private build image `chevereto:tag`.

```sh
docker run -d \
  --name chevereto \
  -p 80:80 \
  -e CHEVERETO_DB_HOST=database \
  -e CHEVERETO_DB_USER=chevereto \
  -e CHEVERETO_DB_PASS=user_database_password \
  -e CHEVERETO_DB_PORT=3306 \
  -e CHEVERETO_DB_NAME=chevereto \
  -e CHEVERETO_ASSET_STORAGE_TYPE=local \
  -e CHEVERETO_ASSET_STORAGE_URL=/images/_assets/ \
  -e CHEVERETO_ASSET_STORAGE_BUCKET=/var/www/html/images/_assets/ \
  -v /var/www/html/images/ \
  chevereto:latest
```

## Run (free edition)

To run [chevereto/chevereto](https://github.com/chevereto/chevereto) (free edition) you need to pass the environment targeting public image `ghcr.io/chevereto/chevereto:tag`.

```sh
docker run -d \
  --name chevereto \
  -p 80:80 \
  -e CHEVERETO_DB_HOST=database \
  -e CHEVERETO_DB_USER=chevereto \
  -e CHEVERETO_DB_PASS=user_database_password \
  -e CHEVERETO_DB_PORT=3306 \
  -e CHEVERETO_DB_NAME=chevereto \
  -e CHEVERETO_ASSET_STORAGE_TYPE=local \
  -e CHEVERETO_ASSET_STORAGE_URL=/images/_assets/ \
  -e CHEVERETO_ASSET_STORAGE_BUCKET=/var/www/html/images/_assets/ \
  -v /var/www/html/images/ \
  ghcr.io/chevereto/chevereto:latest
```

## Using compose

Create your own `docker-compose.yml` at your project folder.

```yml
version: "3.8"

services:
  database:
    image: mariadb:jammy
    networks:
      - chevereto
    volumes:
      - database:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: chevereto
      MYSQL_USER: chevereto
      MYSQL_PASSWORD: user_database_password

  php:
    image: chevereto:latest #tweak with target image to run
    networks:
      - chevereto
    volumes:
      - storage:/var/www/html/images/
    restart: always
    expose:
      - 80
    environment:
      CHEVERETO_DB_HOST: database
      CHEVERETO_DB_USER: chevereto
      CHEVERETO_DB_PASS: user_database_password
      CHEVERETO_DB_PORT: 3306
      CHEVERETO_DB_NAME: chevereto
      CHEVERETO_HOSTNAME: hostname.com #set your hostname
      CHEVERETO_HOSTNAME_PATH: /
      CHEVERETO_HTTPS: 0
      CHEVERETO_ASSET_STORAGE_TYPE: local
      CHEVERETO_ASSET_STORAGE_URL: http://hostname.com/images/_assets/ #hostname-aware URL
      CHEVERETO_ASSET_STORAGE_BUCKET: /var/www/html/images/_assets/

volumes:
  database:
  storage:

networks:
  chevereto:
```
