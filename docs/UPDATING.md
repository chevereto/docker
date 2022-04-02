# Updating

To update it is required to follow these steps:

* Pull `chevereto/container-builder` repo changes
* Re-build the images `make image` (see [BUILD]())
* Down containers `make down`
* [Flush application volume](#flush-application-volume)
* [Re-up containers](DOCKER-COMPOSE.md)

## GitHub one-click updating

1. Go to **Actions**
2. Select **Update** under **Workflows**
3. Click on **Run Workflow** and confirm

![Update template](src/update.png)

🤖 When done **a bot will create a pull request** in your repo so you can review and confirm the changes.

![Update merge](src/update-merge.png)

## Flush application volume

Run the following command to wipe the application volume:

```sh
make app-volume--flush <options>
```

Once removed, on new container `up` the application volume will be re-created with the updated Chevereto files.
