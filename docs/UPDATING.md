# Updating

## Repository update

To update your containers to the latest version of this repository make sure to run first:

```sh
make down
```

💡 If you forget to run this you can rollback the repo and execute the above command.

### Manual updating

Pull this updated repo changes in your fork.

```sh
git fetch --tags -f && git pull
```

### GitHub one-click updating

1. Go to **Actions**
2. Select **Update** under **Workflows**
3. Click on **Run Workflow** and confirm

![Update template](src/update.png)

🤖 When done **a bot will create a pull request** in your repo so you can review and confirm the changes.

![Update merge](src/update-merge.png)

## Chevereto application update

To update to a new Chevereto version first re-build the container image (see [BUILDING](BUILDING.md)) to reflect the target version.

Once done, down and re-up containers by passing the `NAMESPACE` of your project:

```sh
make down NAMESPACE=yourproject
make up-d NAMESPACE=yourproject
```

Refer to [persistance troubleshoot](PERSISTENT.md#no-persistence) If the system prompts to re-install.
