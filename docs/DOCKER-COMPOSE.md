# Docker Compose

This project includes shortcuts for running `docker compose` commands. It uses `default.yml` but it can also use your own compose file.

* Requires [Compose V2](https://docs.docker.com/compose/cli-command/)
* Place a `docker-compose.yml` file to use your own instead of [default.yml](../default.yml)
* Pass `COMPOSE=my-compose` to use `my-compose.yml`

```sh
make <command> <options>
```

## Options

* NAMESPACE=chevereto
* VERSION=4.2
* EDITION=pro
* HTTP_PORT=80
* HTTPS_PORT=443
* HOSTNAME=localhost
* HOSTNAME_PATH=/
* PROTOCOL=http
* COMPOSE=default
* TARGET=default

Example:

```sh
make up HOSTNAME=que.chevere.org PORT=80
```

💡 **TIP:** To ease working with multiple projects use [NAMESPACE](NAMESPACE.md) to pass multiple options stored in a file.

Example:

```sh
make up NAMESPACE=yourproject
```

## Compose files

 By default it uses `default.yml` which is intended to be used in production with nginx proxy.

### Notes on TARGET

`TARGET` affects the project name, container basename and [tag name](BUILDING.md#notes-on-target).

| Target  | Project name            | Container basename              |
| ------- | ----------------------- | ------------------------------- |
| default | NAMESPACE_chevereto     | NAMESPACE_chevereto-VERSION     |
| dev     | NAMESPACE_chevereto-dev | NAMESPACE_chevereto-dev-VERSION |
| any     | NAMESPACE_chevereto-any | NAMESPACE_chevereto-any-VERSION |

Project name will also affect volume naming, which will be prefixed with the project name.

## Up

```sh
make up
```

## Up (daemon)

```sh
make up-d
```

## Stop

```sh
make stop
```

## Start

```sh
make start
```

## Restart

```sh
make restart
```

## Down

```sh
make down
```

## Down volumes

```sh
make down--volumes
```

## Troubleshoot

Check if you are running latest Docker version with [Compose V2](https://docs.docker.com/compose/cli-command/) `docker compose` (not `docker-compose`).

If Docker was included with your Linux distribution check for [Install Docker Engine](https://docs.docker.com/engine/install/) on Linux. Some distributions may be providing old docker engine for LTS compliance, make sure to follow Docker instructions.
