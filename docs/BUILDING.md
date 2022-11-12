# Build

## Make image

This command creates the Docker image for Chevereto by downloading the software at `./chevereto` and then build from [Dockerfile](../Dockerfile).

```sh
make image <options>
```

Available options:

* VERSION=4.0
* TARGET=prod

Example:

```sh
make image VERSION=4.0
```

Images will have a tag named following this convention:

| Target | Naming                | Example           |
| ------ | --------------------- | ----------------- |
| prod   | chevereto:VERSION     | chevereto:4.0     |
| dev    | chevereto-dev:VERSION | chevereto-dev:4.0 |

## Make custom images

This command creates the Docker image for Chevereto copying the contents from `./chevereto` and then build from [Dockerfile](../Dockerfile).

```sh
make image-custom <options>
```

Available options:

* VERSION=4.0
* TARGET=prod

Example:

```sh
make image-custom VERSION=4.0
```
