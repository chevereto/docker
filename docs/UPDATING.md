# Updating

The update process refers to updating existing Chevereto containers to a newly tagged image previously made. Check [UPGRADING](./UPGRADING.md) for the recommended full upgrade process.

## One-click Chevereto updating

Run the following command to update all instances. The process will swap every instance to the new container image and perform the necessary database updates.

```sh
make update
```

## Manual Chevereto updating

Swap to the new container image by down plus up-d by passing the `NAMESPACE` of your project. Once done, execute the `app/bin/legacy -C update` command to perform the necessary database updates.

```sh
make down NAMESPACE=yourproject
make up-d NAMESPACE=yourproject
make exec NAMESPACE=yourproject COMMAND="app/bin/legacy -C update"
```

## Troubleshooting

Refer to [persistance troubleshoot](PERSISTENT.md#no-persistence) If the system prompts to re-install.
