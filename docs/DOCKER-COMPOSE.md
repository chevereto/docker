# docker compose

* Requires [Compose V2](https://docs.docker.com/compose/cli-command/)

```sh
make <command> <options>
```

Available options:

* NAMESPACE=local
* PORT=8040
* VERSION=4.0

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
