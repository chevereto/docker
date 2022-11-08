# Docker

> 🔔 [Subscribe](https://chv.to/newsletter) to don't miss any update regarding Chevereto.

<img alt="Chevereto" src="chevereto.svg" width="100%">

[![Community](https://img.shields.io/badge/chv.to-community-blue?style=flat-square)](https://chv.to/community)

Dockerfile driven template project for building and running container images for Chevereto V4 projects.

> **Warning**: Do not publish image to a public registry as the Chevereto License restricts re-distribution rights.

## Features

* One-click commands using make
* Built-in nginx-proxy manager for supporting multiple hostname

## Requirements

* Chevereto V4 license key
  * [Purchase](https://chevereto.com/pricing) new license
  * [Access](https://chevereto.com/panel/license) existing purchase
* Server with
  * `make`, `unzip`, `curl`
  * [Docker](https://docs.docker.com/)
  * [Compose V2](https://docs.docker.com/compose/cli-command/) `docker compose`

## Quick start

* Get Docker in your system
  * [Docker for Desktop](https://docs.docker.com/get-docker/)
  * [Docker for Server](https://docs.docker.com/engine/install/) (Servers)
* Clone this repository [chevereto/docker](https://github.com/chevereto/docker) (see [SETUP](docs/SETUP.md))

```sh
git clone https://github.com/chevereto/docker.git
```

* Create Chevereto image (requires license)

```sh
make image
```

* Create [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) utilities

```sh
make proxy EMAIL_HTTPS=mail@yourdomain.tld
```

* (Custom) Create `docker-compose.yml` by copying `default.yml`
* (Recommended) Setup [namespace](docs/SETUP.md#namespace)

* Run the container

```sh
make up-d HOSTNAME=<hostname>
```

## Documentation

* [SETUP](./docs/SETUP.md)
* [BUILDING](./docs/BUILDING.md)
* [DOCKER-COMPOSE](./docs/DOCKER-COMPOSE.md)
* [VOLUMES](./docs/VOLUMES.md)
* [HTTPS](./docs/HTTPS.md)
* [UPDATING](./docs/UPDATING.md)
* [PERSISTENT](./docs/PERSISTENT.md)
* [FEEDBACK](./docs/FEEDBACK.md)
