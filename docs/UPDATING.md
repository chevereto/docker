# Updating

The update process consist in that you pull our `chevereto/container-builder` repo changes for updating the Dockerfile. From there you can re-build the image, with the updated changes.

## Manual updating

Refer to the [CONSOLE GUIDE](console/UPDATING.md).

## GitHub one-click updating

1. Go to **Actions**
2. Select **Update** under **Workflows**
3. Click on **Run Workflow** and confirm

![Update template](src/update.png)

🤖 When done **a bot will create a pull request** in your repo so you can review and confirm the changes.

![Update merge](src/update-merge.png)
