# Dev

To develop Chevereto we implement this workflow:

* Create dev image
* Start containers
* Run filesystem watcher

## Create dev image

Dev image is required once and for every change on `Dockerfile`. It is an image without the actual application files (source code).

Run the following command to create the dev image.

```sh
make image-custom TARGET=dev PHP=8.2
```

## Start containers

Run the following command to run docker compose on the Chevereto containers.

```sh
make up-d NAMESPACE=dev
```

## Run filesystem watcher

Run the following command to live update changes (made on local) to the running containers.

```sh
make run SCRIPT=observe NAMESPACE=dev SOURCE=~/git/chevereto/v4
```
