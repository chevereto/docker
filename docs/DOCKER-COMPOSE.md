# Docker Compose

This provides shortcuts for running `docker compose` commands. By default it uses [default.yml](../default.yml) as compose file, customizable with the `COMPOSE` option.

* Requires [Compose V2](https://docs.docker.com/compose/cli-command/)

```sh
make <command> <options>
```

Available options:

* NAMESPACE=chevereto
* VERSION=4.0
* HTTP_PORT=80
* HTTPS_PORT=443
* HOSTNAME=localhost
* HOSTNAME_PATH=/
* PROTOCOL=http
* COMPOSE=default

(*) For `COMPOSE` it points to a Docker compose file at `./projects`.

Example:

```sh
make up HOSTNAME=que.chevere.org PORT=80
```

💡 **TIP:** To ease working with multiple projects use [NAMESPACE](NAMESPACE.md) to pass multiple options stored in a file.

Example:

```sh
make up NAMESPACE=quechevere
```

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
