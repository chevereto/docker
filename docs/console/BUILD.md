# Build (console)

```sh
make build <options>
```

Available options:

* ARCH=arm64v8
* VERSION=4.0
* TAG=chevereto-build:${VERSION}-${ARCH}

## Build httpd.conf

To build your custom [httpd.conf](../../httpd.conf), edit the contents of [chevereto.conf](../../chevereto.conf) and run:

```sh
make build-httpd
```
