# Updating

## Chevereto

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

## Repository

To update your containers to the latest version of this repository make sure to run for every instance:

```sh
make down NAMESPACE=yourproject
```

💡 If you forget to run this you can rollback the repo and execute the above command.

### Manual repo updating

Pull this updated repo changes in your fork.

```sh
git fetch --tags -f && git pull
```

### GitHub one-click repo updating

1. Go to **Actions**
2. Select **Update** under **Workflows**
3. Click on **Run Workflow** and confirm

![Update template](src/update.png)

🤖 When done **a bot will create a pull request** in your repo so you can review and confirm the changes.

![Update merge](src/update-merge.png)

## Troubleshooting

Refer to [persistance troubleshoot](PERSISTENT.md#no-persistence) If the system prompts to re-install.
