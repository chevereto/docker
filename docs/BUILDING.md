# Build

## Build container image

```sh
make image <options>
```

Available options:

* NAMESPACE=local
* VERSION=4.0
* TAG=chevereto-build:${VERSION}-${NAMESPACE}

## Build httpd.conf

To build your custom [httpd.conf](../httpd/httpd.conf), edit the contents of [chevereto.conf](../httpd/chevereto.conf) and run:

```sh
make build-httpd
```
