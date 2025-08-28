# Volumes

Manage Docker volumes. Refer to [PERSISTENT](./PERSISTENT.md) to learn more about volume storage and permissions.

Use `docker volume ls` to list volumes.

## Volume copy

Copies data from one volume to another.

```sh
make volume-cp VOLUME_FROM=<from_volume> VOLUME_TO=<to_volume>
```

💡 [Restart](DOCKER-COMPOSE.md#restart) containers to see changes.

## Volume remove

Removes a volume by name.

```sh
make volume-rm VOLUME=<volume_name>
```

## Volume remove (service)

Remove a volume by `NAMESPACE` and `SERVICE`.

```sh
make volume-rm-service NAMESPACE=yourproject SERVICE=storage
```

## Volume backup (service)

Backup a volume by `NAMESPACE` and `SERVICE` at the `./backup` directory.

```sh
make volume-backup-service NAMESPACE=yourproject SERVICE=storage
```

## Volume restore (service)

Restore a volume by `NAMESPACE` and `SERVICE` at the `./backup` directory.

```sh
make volume-restore-service NAMESPACE=yourproject SERVICE=storage
```
