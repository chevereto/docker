# Build

## Make image

This command creates the Docker images for Apache HTTP and PHP-FPM. It provides Chevereto by downloading the software at `./chevereto`.

```sh
make image <options>
```

Available options:

* NAMESPACE=chevereto
* VERSION=4.0
* TARGET=prod

Example:

```sh
make image VERSION=4.0 NAMESPACE=chevereto
```

Production images will have a tag named following this convention:

| Target | Naming                          | Example                     |
| ------ | ------------------------------- | --------------------------- |
| prod   | NAMESPACE_chevereto:VERSION     | chevereto_chevereto:4.0     |
| dev    | NAMESPACE_chevereto-dev:VERSION | chevereto_chevereto-dev:4.0 |

## Make custom/dev images

Same as production, but it sources the software from `./chevereto` rather than downloading it.

```sh
make image-custom <options>
```

Available options:

* NAMESPACE=chevereto
* VERSION=4.0
* TARGET=prod

Example:

```sh
make image-custom VERSION=4.0 NAMESPACE=chevereto
```
