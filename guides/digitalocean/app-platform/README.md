# DigitalOcean App Platform (WIP)

`this guide is a work in progress`

## Requirements

To use Chevereto with DigitalOcean App Platform you need:

* The **Chevereto image build** already made and available in your DigitalOcean container registry, check table below for repository secrets reference:

| Key               | Description                           |
| ----------------- | ------------------------------------- |
| CHEVERETO_LICENSE | Chevereto license key (*)             |
| REGISTRY_IMAGE    | `chevereto-build`                     |
| REGISTRY_LABEL    | `registry.digitalocean.com/chevereto` |
| REGISTRY_PASSWORD | DigitalOcean PAT                      |
| REGISTRY_USERNAME | DigitalOcean PAT                      |

* A MySQL database (droplet, managed, etc)
* A External Storage provider that will be used to host Chevereto assets
* (recommended) Another External Storage provider for storing user uploads

## Installation

To install Chevereto:

1. Go to **Apps** under **Manage**
2. Click on **Launch Your App**
3. Choose your **chevereto-build** **DigitalOcean Container Registry**
4. Must pass all the environment variables below

```plain
CHEVERETO_DB_HOST=db_ip
CHEVERETO_DB_USER=db_user
CHEVERETO_DB_PASS=db_pass
CHEVERETO_DB_NAME=chevereto
CHEVERETO_HTTPS=0
CHEVERETO_ASSET_STORAGE_TYPE: s3
CHEVERETO_ASSET_STORAGE_URL: https://s3url/my-bucket/
CHEVERETO_ASSET_STORAGE_BUCKET: my-bucket
CHEVERETO_ASSET_STORAGE_KEY: key
CHEVERETO_ASSET_STORAGE_SECRET: secret
```

## Useful links

* Chevereto [Environment](https://v3-docs.chevereto.com/setup/system/environment.html)
* Chevereto [External Storage](https://v3-docs.chevereto.com/features/integrations/external-storage.html)
