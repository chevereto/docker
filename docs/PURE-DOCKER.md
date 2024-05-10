# Pure Docker

This is the most basic way to run Chevereto using Docker.

Pure Docker refers to running Chevereto using Docker without the extra provisions of [Chevereto Docker](README.md) (NGINX ingress proxy, CloudFlare integration).

## Build image (paid edition)

Image building is **required** for Chevereto **paid edition**. Skip to [Run (free edition)](#run-free-edition) if you are using Chevereto free edition.

### Clone repository

Clone the [chevereto/docker](https://github.com/chevereto/docker) repository and create an `.env` file with your license key:

```sh
CHEVERETO_LICENSE_KEY=your_license_key
```

### Make image

Run the following command to create the Chevereto image:

```sh
make image
```

By running the above command you will generate the following tags:

* `chevereto:latest`
* `chevereto:4`
* `chevereto:4.1`
* `chevereto:4.1.0`

## Upgrading

To upgrade your Chevereto application you need to (1) Sync repository, (2) Re-build the container image, and (3) Down and re-up the container.

### Step 1: Sync repository

Sync latest changes from [chevereto/docker](https://github.com/chevereto/docker) repository:

```sh
make sync
```

**Note:** If there's a new branch (for example 4.2) switch to that branch running the following command:

```sh
git switch 4.2
```

### Step 2: Re-build the container image

```sh
make image
```

### Step 3: Down and re-up the container

Down the container:

```sh
docker stop --name chevereto
docker rm --name chevereto
```

Then re-up the container using the same command you used to run it the first time.

## Run (paid edition)

To run [chevereto.com](https://chevereto.com/pricing) (paid edition) you need to pass the environment targeting your private build image, in this example `chevereto:latest`.

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
  -e CHEVERETO_MAX_POST_SIZE=2G \
  -e CHEVERETO_MAX_UPLOAD_SIZE=2G \
  -v /var/www/html/images/ \
  chevereto:latest
```

## Run (free edition)

To run [chevereto/chevereto](https://github.com/chevereto/chevereto) (Chevereto free edition) you need to pass the environment targeting public image `ghcr.io/chevereto/chevereto:latest`.

Alternatively, you can pass `chevereto/chevereto:latest` which is the [Chevereto mirror on DockerHub](https://hub.docker.com/r/chevereto/chevereto).

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
  -e CHEVERETO_MAX_POST_SIZE=2G \
  -e CHEVERETO_MAX_UPLOAD_SIZE=2G \
  -v /var/www/html/images/ \
  ghcr.io/chevereto/chevereto:latest
```

## Using compose

Create your own `docker-compose.yml` at your project folder.

```yml
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
    image: chevereto/chevereto:latest #tweak with target image to run
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
