# Container builder

> 🔔 [Subscribe](https://newsletter.chevereto.com/subscription?f=PmL892XuTdfErVq763PCycJQrvZ8PYc9JbsVUttqiPV1zXt6DDtf7lhepEStqE8LhGs8922ZYmGT7CYjMH5uSx23pL6Q) to don't miss any update regarding Chevereto.

<img alt="Chevereto" src="chevereto.svg" width="100%">

[![Community](https://img.shields.io/badge/chv.to-community-blue?style=flat-square)](https://chv.to/community)

Dockerfile template project for building and distributing container images for Chevereto projects to any container registry.

## Note

**Do not publish** the generated image to a public registry as the Chevereto License restricts re-distribution rights.

## Requirements

* `docker compose` >= 2.0

## Quick start

1. Clone this repository (see [SETUP](docs/SETUP.md))
2. Create your image `make image`
3. Start your containers `make up--d`

## Documentation

* [SETUP](./docs/SETUP.md)
* [BUILDING](./docs/BUILDING.md)
* [DOCKER-COMPOSE](./docs/DOCKER-COMPOSE.md)
* [UPDATING](./docs/UPDATING.md)
* [PERSISTENT](./docs/PERSISTENT.md)
