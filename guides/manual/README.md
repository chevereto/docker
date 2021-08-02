# Console

## Build image

Running this command from the top folder of this repository.

* For **arm64v8** architecture:

```sh
docker build -t chevereto-build:latest-httpd-php-arm64v8 . \
    -f httpd-php.Dockerfile \
    --build-arg CHEVERETO_LICENSE=<license> \
    --build-arg ARCH=arm64v8
```

* For **amd64** architecture:

```sh
docker build -t chevereto-build:latest-httpd-php-amd64 . \
    -f httpd-php.Dockerfile \
    --build-arg CHEVERETO_LICENSE=<license> \
    --build-arg ARCH=amd64
```

## Using docker compose

> Run all the following commands from the top folder of this repository.

Run Chevereto, it will be available at [https://localhost:8096](https://localhost:8096) by default:

```sh
docker compose \
    -f guides/docker-compose/httpd-php-arm64v8.yml \
    up -d
```

Stop Chevereto:

```sh
docker compose \
    -f guides/docker-compose/httpd-php-arm64v8.yml \
    stop
```

Start Chevereto.

```sh
docker compose \
    -f guides/docker-compose/httpd-php-arm64v8.yml \
    start
```

Stop and remove Chevereto(*).

```sh
docker compose \
    -f guides/docker-compose/httpd-php-arm64v8.yml \
    down
```

**Note**: This won't remove the volumes for persistent data storage.
