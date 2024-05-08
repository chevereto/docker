# Updating

**Note:** To update make sure to update your copy of this repo (refer to [REPO SYNCING](./REPO-SYNCING.md)) and from there you can update Chevereto application.

## Chevereto application update

To update instances to a new Chevereto version re-build the container image (see [BUILDING](BUILDING.md)) to reflect the target version.

### One-click Chevereto updating

Run the following command to update all instances. The process will swap every instance to the new container image and perform the necessary database updates.

```sh
make update
```

### Manual Chevereto updating

Swap to the new container image by down plus up-d by passing the `NAMESPACE` of your project. Once done, execute the `app/bin/legacy -C update` command to perform the necessary database updates.

```sh
make down NAMESPACE=yourproject
make up-d NAMESPACE=yourproject
make exec NAMESPACE=yourproject COMMAND="app/bin/legacy -C update"
```


## Troubleshooting

Refer to [persistance troubleshoot](PERSISTENT.md#no-persistence) If the system prompts to re-install.
