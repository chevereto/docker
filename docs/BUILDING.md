# Build

## Make production images

This command creates the Docker images for Apache HTTP and PHP-FPM. It provides Chevereto by downloading the software at `./chevereto`.

```sh
make image <options>
```

Available options:

* NAMESPACE=local
* VERSION=4.0

Example:

```sh
make image VERSION=4.0 NAMESPACE=donchecho
```

## Make custom images

Same as production, but it sources the software from `./chevereto` rather than downloading it.

```sh
make image-custom <options>
```

Available options:

* NAMESPACE=local
* VERSION=4.0
* TAG_BASENAME=${NAMESPACE}_chevereto:${VERSION}

Example:

```sh
make image-custom VERSION=4.0 NAMESPACE=donchecho TAG_BASENAME=mywea
```
