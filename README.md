# Docker

> 🔔 [Subscribe](https://chv.to/newsletter) to don't miss any update regarding Chevereto.

<img alt="Chevereto" src="chevereto.svg" width="100%">

[![Community](https://img.shields.io/badge/chv.to-community-blue?style=flat-square)](https://chv.to/community)

Dockerfile driven template project for building images and manage containers for Chevereto V4 projects.

> **Warning**: Do not publish Docker images to a public registry when using a paid Chevereto edition as its [commercial license](https://chevereto.com/license) restricts re-distribution rights.

## Features

* One-click commands using `make`
* Built-in HTTP ingress using nginx-proxy for multiple instances
* Automatic renewable HTTPS using Let's Encrypt
* One-click Chevereto updates
* Integrated with CloudFlare API (automatic sub-domain handling)
* Pure Docker instructions

## Requirements

`To follow this guide, make sure you have:

* A Ubuntu server with shell access and public IP address.
* A domain managed by CloudFlare (if using integration)
* A Chevereto license (required for the paid edition)
  * [Purchase](https://chevereto.com/pricing) new license
  * [Access](https://chevereto.com/panel/license) existing purchase`

## Quick-start

Run the following command to install this project and all its dependencies in your brand new **Ubuntu 22.04** server.

```sh
bash <(curl -s https://chevereto.com/sh/ubuntu/22.04/docker.sh)
```

Create configuration file at `.env` by running this command.

```sh
make env
```

Run the following command to setup the system.

```sh
make setup
```

If using Chevereto paid edition, build the Chevereto image by running this command.

```sh
make image
```

### Deploying websites

To deploy a new website use the following command format.

```sh
make deploy NAMESPACE={namespace} ADMIN_EMAIL={email}
```

Replace `{namespace}` with the desired project name and `{email}` with the admin email for the website.

### Destroying websites

To destroy a website use the following command format.

```sh
make destroy NAMESPACE={namespace}
```

Replace `{namespace}` with the desired project name to destroy.

## Pure Docker

If you want full control of the container provisioning you can get our base image at:

```sh
ghcr.io/chevereto/chevereto:latest
```

You can get this container running with the following command:

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

See [PURE-DOCKER](docs/PURE-DOCKER.md) for a complete pure Docker command reference.

## Manual setup

* Clone this repository [chevereto/docker](https://github.com/chevereto/docker) (see [SETUP](docs/SETUP.md#clone))

```sh
git clone https://github.com/chevereto/docker.git
```

* Get Docker in your Ubuntu server

```sh
make install-docker
```

You may also check [Docker for Desktop](https://docs.docker.com/get-docker/) and [Docker Engine](https://docs.docker.com/engine/install/) (servers) instructions.

* Create `.env` configuration file

```sh
make env
```

* Create Cron (see [SETUP](docs/SETUP.md#cron))

```sh
make cron
```

* Create [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy)

```sh
make proxy EMAIL_HTTPS=mail@yourdomain.tld
```

## Build Chevereto image

Omit this step when using free edition as the image is available at [GHCR](https://github.com/chevereto/chevereto/pkgs/container/chevereto).

* Create Chevereto image (see [SETUP](docs/SETUP.md#custom-application))

```sh
make image
```

## Create a NAMESPACE

* Setup a [NAMESPACE](docs/NAMESPACE.md) for your website project

```sh
make namespace NAMESPACE=yourproject HOSTNAME=yourdomain.tld
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
