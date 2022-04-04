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

* Get Docker in your system
* Clone this repository [chevereto/v4-container-builder](https://github.com/chevereto/v4-container-builder) (see [SETUP](docs/SETUP.md))

```sh
git clone https://github.com/v4-container-builder.git
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
