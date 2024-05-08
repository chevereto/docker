# Volumes

Manage Docker volumes. Refer to [PERSISTENT](./PERSISTENT.md) to learn more about volume storage and permissions.

## Volume copy

```sh
make volume-cp VOLUME_FROM=<from_volume> VOLUME_TO=<to_volume>
```

💡 [Restart](DOCKER-COMPOSE.md#restart) containers to see changes.

## Volume remove

```sh
make volume-rm VOLUME=<volume_name>
```
