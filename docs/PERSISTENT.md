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
www-data@20d1427c6727:~/html$ ls -la
total 52
drwxrwxrwx  8 www-data www-data 4096 Apr  1 18:56 .
drwxr-xr-x  1 root     root     4096 Mar 29 01:50 ..
-rw-r--r--  1 www-data www-data    0 Aug  2  2021 .gitkeep
-rw-r--r--  1 www-data www-data 1342 Mar 21 20:26 .htaccess
-rw-r--r--  1 www-data www-data 6009 Mar 21 20:26 LICENSE
drwxr-xr-x  2 root     root     4096 Apr  1 18:52 _assets
drwxr-xr-x 11 www-data www-data 4096 Apr  1 18:55 app
drwxr-xr-x  5 www-data www-data 4096 Apr  1 18:56 content
drwxr-xr-x  3 www-data www-data 4096 Apr  1 18:53 images
drwxr-xr-x  5 www-data www-data 4096 Apr  1 18:56 importing
-rw-r--r--  1 www-data www-data  290 Mar 21 20:26 index.php
drwxr-xr-x  2 www-data www-data 4096 Apr  1 18:56 sdk
```

## Volume reference

| Volume                  | Mount path             | Purpose                              |
| ----------------------- | ---------------------- | ------------------------------------ |
| [chevereto](#chevereto) | /var/www/html/         | Chevereto application files          |
| [storage](#storage)     | /var/www/html/images/  | User uploads                         |
| [assets](#assets)       | /var/www/html/_assets/ | Website assets (avatars, logos, etc) |

### Chevereto

This volume is for storing the application files shared between containers `php` and `http`.

👉 This keep the application files shared between containers.

### Storage

This volume is for storing user uploaded images.

👉 This is used when you don't add any External Storage provider to Chevereto.

### Assets

This volume is used for storing Chevereto assets namely user avatars, website logos, background images, etc.

👉 This is used when you configure asset storage for use the `local` External Storage API.
