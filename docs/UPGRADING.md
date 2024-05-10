# Upgrading

The upgrade process refer to (1) Syncing this repository, (2) Re-build the Chevereto container image and (3) Update your running containers.

🪄 Follow the steps below to easy upgrade your Chevereto instances.

## Step 1: Sync

Sync this repository to get the latest changes.

```sh
make sync
```

**Note:** If there's a new branch (for example 4.2) switch to that branch running the following command:

```sh
git switch 4.2
```

## Step 2: Re-build the container image

Build the container image to reflect the newest version.

```sh
make image
```

## Step 3: Update Chevereto instances

```sh
make update
```
