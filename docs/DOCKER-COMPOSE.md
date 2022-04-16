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

Check if you are running [Compose V2](https://docs.docker.com/compose/cli-command/) `docker compose` (not `docker-compose`).
