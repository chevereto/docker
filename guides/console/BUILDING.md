# Building (console)

> Note: Running the command from the top folder of this repository.

* Change `<license>` with your Chevereto license.

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
