# Console

## Build image

Running this command from the top folder of this repository.

* **amd64**

```sh
docker build -t chevereto-build:latest-httpd-php-amd64 . \
    -f httpd-php.Dockerfile \
    --build-arg CHEVERETO_LICENSE=<license> \
    --build-arg ARCH=amd64
```

* **arm64v8**

```sh
docker build -t chevereto-build:latest-httpd-php-arm64v8 . \
    -f httpd-php.Dockerfile \
    --build-arg CHEVERETO_LICENSE=<license> \
    --build-arg ARCH=arm64v8
```

## Using docker compose

> Run all the following commands from the top folder of this repository.

Refer to [docker-compose/](../../docker-compose/) directory for all the compose files examples you can use.

### Up

Run Chevereto, it will be available at [https://localhost:8096](https://localhost:8096) by default:

* **arm64v8**

```sh
docker compose \
    -f docker-compose/httpd-php-arm64v8.yml \
    up -d
```

* **amd64**

```sh
docker compose \
    -f docker-compose/httpd-php-amd64.yml \
    up -d
```

### Stop

* **arm64v8**

```sh
docker compose \
    -f docker-compose/httpd-php-arm64v8.yml \
    stop
```

* **amd64**

```sh
docker compose \
    -f docker-compose/httpd-php-amd64.yml \
    stop
```

### Start

* **arm64v8**

```sh
docker compose \
    -f docker-compose/httpd-php-arm64v8.yml \
    start
```

* **amd64**

```sh
docker compose \
    -f docker-compose/httpd-php-amd64.yml \
    start
```

### Down

* **arm64v8**

```sh
docker compose \
    -f docker-compose/httpd-php-arm64v8.yml \
    down
```

* **amd64**

```sh
docker compose \
    -f docker-compose/httpd-php-amd64.yml \
    down
```

**Note**: This won't remove the volumes for persistent data storage.
