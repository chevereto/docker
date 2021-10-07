# Persistent storage

## Using Services

Chevereto supports using external storage providers for user provided content and website assets. It support any mixture of configurations as you may need to customize.

For more information:

* [External Storage](https://v3-docs.chevereto.com/features/integrations/external-storage.html) documentation
* [Assets Variables](https://v3-docs.chevereto.com/setup/system/environment.html#assets-variables) reference

## Using Volumes

If you are using volumes for persistent storage, permissions in the mount path must be `www-data:www-data` to enable Chevereto to write those volumes.

Run this command in the Chevereto container to set the right permissions:

```sh
/bin/bash -c 'chown -R www-data: _assets/ images/ importing/'
```

## Permissions check

Enter to the container console `/bin/bash`. Once there, run `ls -la` and you should see something like this:

```plain
root@688cf7e6d94f:/var/www/html# ls -la
total 188
drwxrwxrwx  1 www-data www-data   4096 Jun 23 15:13 .
drwxr-xr-x  1 root     root       4096 Jun 23 15:13 ..
-rw-r--r--  1 www-data www-data   1310 Jun 23 15:13 .htaccess
drwxr-xr-x  2 www-data www-data   4096 Jun 23 15:13 _assets
drwxr-xr-x 10 www-data www-data   4096 Jun 23 15:13 app
-rw-r--r--  1 www-data www-data    982 Jun 23 15:13 cli.php
-rw-r--r--  1 www-data www-data   1184 Jun 23 15:13 composer.json
-rw-r--r--  1 www-data www-data 138063 Jun 23 15:13 composer.lock
drwxr-xr-x  4 www-data www-data   4096 Jun 23 15:13 content
drwxr-xr-x  2 www-data www-data   4096 Jun 23 15:13 images
drwxr-xr-x  6 www-data www-data   4096 Jun 23 16:47 importing
-rw-r--r--  1 www-data www-data    599 Jun 23 15:13 index.php
drwxr-xr-x  4 www-data www-data   4096 Jun 23 15:13 lib
drwxr-xr-x  2 www-data www-data   4096 Jun 23 15:13 sdk
```

## Volume reference

| Volume      | Mount path             | Purpose                              |
| ----------- | ---------------------- | ------------------------------------ |
| chv-storage | /var/www/html/images/  | User uploads                         |
| chv-assets  | /var/www/html/_assets/ | Website assets (avatars, logos, etc) |

### `chv-storage`

This volume is used to store user uploaded images in the same filesystem where Chevereto is running. This is used when you don't add any External Storage provider to Chevereto.

### `chv-assets`

This volume is used to store the Chevereto assets namely user avatars, website logos, background images, etc. This is used when you configure asset storage for use the `local` External Storage API.
