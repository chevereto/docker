# Building (console)

> Note: Running the command from the top folder of this repository.

* Change `YOUR_V3_LICENSE_KEY` with your Chevereto license.

* **amd64**

```sh
docker build -t chevereto-build:latest-httpd-php-amd64 . \
    -f httpd-php.Dockerfile \
    --build-arg CHEVERETO_LICENSE=YOUR_V3_LICENSE_KEY \
    --build-arg ARCH=amd64
```

* **arm64v8**

```sh
docker build -t chevereto-build:latest-httpd-php-arm64v8 . \
    -f httpd-php.Dockerfile \
    --build-arg CHEVERETO_LICENSE=YOUR_V3_LICENSE_KEY \
    --build-arg ARCH=arm64v8
```
