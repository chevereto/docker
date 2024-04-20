# Build

## Make image

This command creates the Docker image for Chevereto by downloading the software at `./chevereto` and then build from [Dockerfile](../Dockerfile). It will generate multiple semantic version tags `4.1.0`, `4.1` and `4`.

```sh
make image <options>
```

### Options

| Option  | Example          | Description                  |
| ------- | ---------------- | ---------------------------- |
| VERSION | `VERSION=4.1`    | System version (4.x)         |
| EDITION | `EDITION=pro`    | System edition (pro,free)    |
| TARGET  | `TARGET=default` | Image base name suffix (any) |

Example:

```sh
make image VERSION=4.1
```

### Notes on TARGET

Images will have a tag named following this convention:

| Target  | Naming                | Example           |
| ------- | --------------------- | ----------------- |
| default | chevereto:VERSION     | chevereto:4.1     |
| dev     | chevereto-dev:VERSION | chevereto-dev:4.1 |
| any     | chevereto-any:VERSION | chevereto-any:4.1 |

## Make custom images

This command creates the Docker image for Chevereto copying the contents from `./chevereto` and then build from [Dockerfile](../Dockerfile).

```sh
make image-custom <options>
```

Available options:

* VERSION=4.1
* TARGET=default

Example:

```sh
make image-custom VERSION=4.1
```
