# Pure Docker

## Build image

Image building is required for Chevereto **paid edition**. To ease the process we provide a script to build the image, you can find it at [scripts/system/chevereto.sh](https://github.com/chevereto/docker/blob/4.1/scripts/system/chevereto.sh).

```sh
VERSION=4.1 \
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
* `chevereto:4.1`
* `chevereto:4.1.0`

## Run (paid edition)

To run [chevereto.com](https://chevereto.com/pricing) (paid edition) you need to pass the environment targeting your private build image, in this case `chevereto:latest`.

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

To run [chevereto/chevereto](https://github.com/chevereto/chevereto) (free edition) you need to pass the environment targeting public image `ghcr.io/chevereto/chevereto:latest`.

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
version: "3.9"

services:
  database:
    image: mariadb:jammy
    networks:
      - chevereto
    volumes:
      - database:/var/lib/mysql
    restart: always
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--su-mysql", "--connect"]
      interval: 10s
      timeout: 5s
      retries: 3
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
    depends_on:
      database:
        condition: service_healthy
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
      CHEVERETO_MAX_POST_SIZE: 2G
      CHEVERETO_MAX_UPLOAD_SIZE: 2G

volumes:
  database:
  storage:

networks:
  chevereto:
```
