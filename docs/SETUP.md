# Setup

## Clone

Clone this repository using git:

```sh
git clone https://github.com/chevereto/docker.git
```

## Cron

Setup Cron for all instances:

```sh
make cron
```

## Custom application

Put the contents of your custom Chevereto based application in the `/chevereto` folder before [building](BUILDING.md#make-custom-images) the image using the `make image-custom command`.

## Custom compose

To customize the compose file, create `docker-compose.yml` by copying [default.yml](../default.yml).
