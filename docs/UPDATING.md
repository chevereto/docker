# Updating

## Repository update

### Manual updating

Pull this updated repo changes in your fork.

### GitHub one-click updating

1. Go to **Actions**
2. Select **Update** under **Workflows**
3. Click on **Run Workflow** and confirm

![Update template](src/update.png)

🤖 When done **a bot will create a pull request** in your repo so you can review and confirm the changes.

![Update merge](src/update-merge.png)

## Chevereto update

To update Chevereto make sure to update this repository, then follow these steps:

1. Re-build the images (see [BUILDING](BUILDING.md))
2. Down containers (see [DOCKER-COMPOSE](DOCKER-COMPOSE.md#down))
3. [Flush application volume](#flush-application-volume)
4. [Re-up containers](DOCKER-COMPOSE.md#up-daemonized)

### Flush application volume

Run the following command to wipe the application volume:

```sh
make chevereto-volume-rm <options>
```

Once removed, on new container `up` the application volume will be re-created with the updated Chevereto files.
