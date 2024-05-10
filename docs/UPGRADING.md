# Upgrading

To upgrade you need to (1) Sync repository, (2) Re-build the container image, and (3) Update Chevereto instances.

## Step 1: Sync repository

Sync this repository to get the latest changes.

```sh
make sync
```

**Note:** If there's a new branch (for example 4.2) switch to that branch running the following command:

```sh
git switch 4.2
```

## Step 2: Re-build the container image

Build a new container image to reflect the newest release.

```sh
make image
```

## Step 3: Update Chevereto instances

This will down and re-up the containers and carry the required database update.

```sh
make update
```
