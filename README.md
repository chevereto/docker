# V4 Docker production

> 🔔 [Subscribe](https://chv.to/newsletter) to don't miss any update regarding Chevereto.

<img alt="Chevereto" src="chevereto.svg" width="100%">

[![Community](https://img.shields.io/badge/chv.to-community-blue?style=flat-square)](https://chv.to/community)

Dockerfile driven template project for building and running container images for Chevereto V4 projects.

> **Warning**: Do not publish generated image to a public registry as the Chevereto License restricts re-distribution rights.

## Requirements

* [Docker](https://docs.docker.com/)
* [Compose V2](https://docs.docker.com/compose/cli-command/) `docker compose`

## Quick start

* [Get Docker](https://docs.docker.com/get-docker/) in your system
* Clone this repository [chevereto/v4-docker-production](https://github.com/chevereto/v4-docker-production) (see [SETUP](docs/SETUP.md))

```sh
git clone https://github.com/chevereto/v4-docker-production.git
```

* From the repository folder run:

```sh
make image
```

```sh
make up-d
```

## Documentation

* [SETUP](./docs/SETUP.md)
* [BUILDING](./docs/BUILDING.md)
* [DOCKER-COMPOSE](./docs/DOCKER-COMPOSE.md)
* [UPDATING](./docs/UPDATING.md)
* [PERSISTENT](./docs/PERSISTENT.md)
