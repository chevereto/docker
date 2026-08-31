# Dev

To develop Chevereto we implement this workflow:

* Create dev image
* Start containers

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
