# Portainer

## Requirements

To use this system with [Portainer](https://www.portainer.io/) you need the Chevereto image build already made and available in the private container registry of your choice.

## Installation

1. Install Portainer
2. Once installed, go to **Registries**
3. Add the user credentials for your container registry

## Chevereto in Portainer

### docker-compose

Build your own `docker-compose` file by grabbing [httpd-php.dist.yml](../docker-compose/httpd-php.dist.yml) and change:

```yml
  chv-build:
    image: rodber/docker-build:latest-httpd-php
```

To this:

```yml
  chv-build:
    image: your_image_here
```

### Adding Chevereto as a Portainer custom application

1. Go to **App Templates** and then click on **Custom Templates**
1. Click on **Add Custom Template**
2. Fill the required information
   1. Title: Chevereto
   2. Description: My Chevereto
   3. Icon URL: `https://chevereto.com/src/icons/logo.svg`
   4. Platform: **Linux**
   5. Type: **Standalone**
3. **Under Build method** select **Web editor** and provide your [docker-compose](#docker-compose) file contents
4. Finish by clicking on **Create custom template**

When done, Chevereto will be available in the custom applications list.

### Deploying Chevereto in Portainer

1. Go to **Custom Templates**, click **Chevereto**
2. Choose your deploy options
3. Finish by clicking on **Deploy the stack**

## Volumes & Permissions

| Volume      | Mount path             | Purpose                              |
| ----------- | ---------------------- | ------------------------------------ |
| chv-storage | /var/www/html/images/  | User uploads                         |
| chv-assets  | /var/www/html/_assets/ | Website assets (avatars, logos, etc) |

Permissions in the mount path must be `www-data:www-data`

### `chv-storage`

This volume is used to store user uploaded images in the same filesystem where Chevereto is running. This is used when you don't add any External Storage provider to Chevereto.

### `chv-assets`

This volume is used to store the Chevereto assets namely user avatars, website logos, background images, etc. This is used when you configure asset storage for use the `local` External Storage API.

## Useful links

* Chevereto [Environment](https://v3-docs.chevereto.com/setup/system/environment.html)
* Chevereto [External Storage](https://v3-docs.chevereto.com/features/integrations/external-storage.html)
