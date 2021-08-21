# Portainer

## Requirements

To use Chevereto with [Portainer](https://www.portainer.io/) you need the **Chevereto image build** already made and available in the private container registry of your choice.

## Installation

1. Install **Portainer** following the instructions for your system.

If you are using a remote container registry such as Docker hub and others:

1. Go to **Registries**
2. Add the user credentials for your **container registry**

## Adding Chevereto as a Portainer custom application

**NOTE:** [Portainer CE 2.1.1](https://www.portainer.io/blog/portainer-release-2.1.1) supports docker-compose > 3 for standalone hosts **ONLY for amd64** architecture. This guide won't work when using arm64, for which case you can manually run `docker compose` following our [MANUAL GUIDE](../manual/README.md).

1. Open Portainer and go to endpoint **Dashboard**
2. Go to **App Templates** and then click on **Custom Templates**
3. Click on **Add Custom Template**
4. Fill the required information
   1. **Title:** Chevereto
   2. **Description:** My Chevereto
   3. **Icon URL:** `https://chevereto.com/src/icons/logo.svg`
   4. **Platform:** Linux
   5. **Type:** Standalone
5. **Under Build method** select **Web editor** and provide your [docker-compose](#docker-compose) file contents
6. Finish by clicking on **Create custom template**

When done, Chevereto will be available in the custom applications list.

### docker-compose

* [httpd-php-amd64.yml](../../docker-compose/httpd-php-amd64.yml)
* [httpd-php-arm64v8.yml](../../docker-compose/httpd-php-arm64v8.yml)

If you want to use a custom image tag or registry change:

```yml
  chv-build:
    image: chevereto-build:latest-httpd-php-amd64
```

To this, where `your_image_here` references your private image tag.

```yml
  chv-build:
    image: your_image_here
```

You may alter the default provisioning to change HTTPS behavior, set a external storage provider for assets, etc. By default this guide only uses local volumes.

## Deploying

1. Go to **Custom Templates**, click **Chevereto**
2. Choose your deploy options
3. Finish by clicking on **Deploy the stack**

By default, Chevereto will be available at [localhost:8016](http://localhost:8016)

When deploying for the **first time**, the volumes will be created and you will **require to fix its permissions**.

* Check [PERSISTENT](../PERSISTENT.md#using-volumes)

## Updating

You will need to [update your template](../../UPDATING.md) then [re-create the build](../../BUILDING.md).

Once the container image gets re-build, you can re-create the container in Portainer:

1. Go to your `*chv-build-*` container and click on **Recreate**
2. Make sure to enable **Pull latest image**

The container will be re-created with the updated application layer. Data in your volumes will persist.

## Useful links

* Chevereto [Environment](https://v3-docs.chevereto.com/setup/system/environment.html)
* Chevereto [External Storage](https://v3-docs.chevereto.com/features/integrations/external-storage.html)

## Volume reference

In this Portainer guide persisten storage is provided using volumes. This volume reference is just for purposes of this Portainer guide.

| Volume      | Mount path             | Purpose                              |
| ----------- | ---------------------- | ------------------------------------ |
| chv-storage | /var/www/html/images/  | User uploads                         |
| chv-assets  | /var/www/html/_assets/ | Website assets (avatars, logos, etc) |

### `chv-storage`

This volume is used to store user uploaded images in the same filesystem where Chevereto is running. This is used when you don't add any External Storage provider to Chevereto.

### `chv-assets`

This volume is used to store the Chevereto assets namely user avatars, website logos, background images, etc. This is used when you configure asset storage for use the `local` External Storage API.
