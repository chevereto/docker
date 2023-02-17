# Docker

> 🔔 [Subscribe](https://chv.to/newsletter) to don't miss any update regarding Chevereto.

<img alt="Chevereto" src="chevereto.svg" width="100%">

[![Community](https://img.shields.io/badge/chv.to-community-blue?style=flat-square)](https://chv.to/community)

Dockerfile driven template project for building images and manage containers for Chevereto V4 projects.

> **Warning**: Do not publish Docker images to a public registry when using a paid Chevereto edition as its [commercial license](https://chevereto.com/license) restricts re-distribution rights.

## Features

* One-click commands using `make`
* Built-in nginx-proxy for multiple instances
* Pure Docker instructions
* Integrated with CloudFlare API

## Requirements

* Chevereto V4 license key (for paid edition)
  * [Purchase](https://chevereto.com/pricing) new license
  * [Access](https://chevereto.com/panel/license) existing purchase
* Server with
  * Shell access
  * `make`, `unzip`, `curl` and `git`
  * [Docker](https://docs.docker.com/)
  * [Compose V2](https://docs.docker.com/compose/cli-command/) `docker compose`
* Hostname pointing to server
* See [CLOUDFLARE](./docs/CLOUDFLARE.md) when using CloudFlare

## Pure Docker

Refer to [PURE-DOCKER](docs/PURE-DOCKER.md) for a complete pure Docker command reference.

```sh
docker run -d \
  --name chevereto \
  -p 80:80 \
  -e CHEVERETO_DB_HOST=database \
  -e CHEVERETO_DB_USER=chevereto \
  -e CHEVERETO_DB_PASS=user_database_password \
  -e CHEVERETO_DB_PORT=3306 \
  -e CHEVERETO_DB_NAME=chevereto \
  -e CHEVERETO_ASSET_STORAGE_TYPE=local \
  -e CHEVERETO_ASSET_STORAGE_URL=/images/_assets/ \
  -e CHEVERETO_ASSET_STORAGE_BUCKET=/var/www/html/images/_assets/ \
  -v /var/www/html/images/ \
  ghcr.io/chevereto/chevereto:latest
```

## Quick setup

* Clone this repository [chevereto/docker](https://github.com/chevereto/docker) (see [SETUP](docs/SETUP.md#clone))

```sh
git clone https://github.com/chevereto/docker.git
```

* Get Docker in your Ubuntu server

```sh
make install-docker
```

You may also check [Docker for Desktop](https://docs.docker.com/get-docker/) and [Docker Engine](https://docs.docker.com/engine/install/) (servers) instructions

* Create Cron (see [SETUP](docs/SETUP.md#cron))

```sh
make cron
```

* Create [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy)

```sh
make proxy EMAIL_HTTPS=mail@yourdomain.tld
```

## Build Chevereto image

💡 Omit this step when using free edition as the image is available at [GHCR](https://github.com/chevereto/chevereto/pkgs/container/chevereto).

* Create Chevereto image (see [SETUP](docs/SETUP.md#custom-application))

```sh
make image
```

## Create a NAMESPACE

* Setup a [NAMESPACE](docs/NAMESPACE.md) for your website project

```sh
make namespace NAMESPACE=yourproject HOSTNAME=yourdomain.tld
```

## Spawn Chevereto instance

* Run the Chevereto container using [spawn](docs/DOCKER-COMPOSE.md#spawn):

```sh
make spawn NAMESPACE=yourproject
```

* 💡 When using free edition pass `EDITION=free`:

```sh
make spawn NAMESPACE=yourproject EDITION=free
```

## Documentation

* [SETUP](./docs/SETUP.md)
* [NAMESPACE](docs/NAMESPACE.md)
* [BUILDING](./docs/BUILDING.md)
* [DOCKER-COMPOSE](./docs/DOCKER-COMPOSE.md)
* [VOLUMES](./docs/VOLUMES.md)
* [HTTPS](./docs/HTTPS.md)
* [CLOUDFLARE](./docs/CLOUDFLARE.md)
* [UPDATING](./docs/UPDATING.md)
* [PERSISTENT](./docs/PERSISTENT.md)
* [FEEDBACK](./docs/FEEDBACK.md)
