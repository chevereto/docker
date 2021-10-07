# Docker compose

> Run all the following commands from the top folder of this repository.

## Up

Run Chevereto, it will be available at [http://localhost:8030](http://localhost:8030) by default:

* **arm64v8**

```sh
docker compose \
    -f httpd-php-arm64v8.yml \
    up -d
```

* **amd64**

```sh
docker compose \
    -f httpd-php-amd64.yml \
    up -d
```

## Stop

* **arm64v8**

```sh
docker compose \
    -f httpd-php-arm64v8.yml \
    stop
```

* **amd64**

```sh
docker compose \
    -f httpd-php-amd64.yml \
    stop
```

## Start

* **arm64v8**

```sh
docker compose \
    -f httpd-php-arm64v8.yml \
    start
```

* **amd64**

```sh
docker compose \
    -f httpd-php-amd64.yml \
    start
```

## Down

* **arm64v8**

```sh
docker compose \
    -f httpd-php-arm64v8.yml \
    down
```

* **amd64**

```sh
docker compose \
    -f httpd-php-amd64.yml \
    down
```

**Note**: This won't remove the volumes for persistent data storage.
