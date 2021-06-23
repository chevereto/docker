# Container builder

> 🔔 [Subscribe](https://newsletter.chevereto.com/subscription?f=PmL892XuTdfErVq763PCycJQrvZ8PYc9JbsVUttqiPV1zXt6DDtf7lhepEStqE8LhGs8922ZYmGT7CYjMH5uSx23pL6Q) to don't miss any update regarding Chevereto.

![Chevereto](LOGO.svg)

[![Community](https://img.shields.io/badge/chv.to-community-blue?style=flat-square)](https://chv.to/community)
[![Discord](https://img.shields.io/discord/759137550312407050?style=flat-square)](https://chv.to/discord)
[![Twitter Follow](https://img.shields.io/twitter/follow/chevereto?style=social)](https://twitter.com/chevereto)

Dockerfile template project for building and distributing container images for Chevereto (ahead) releases to any container registry. It also works with custom applications.

## Note

Do not publish the generated image to a public access registry as it contains your licensed installation files (including your key).

🧐 Handle it with care or your license details could be stolen.

## GitHub Setup

* Click the [Use this template](https://github.com/chevereto/docker-builder/generate) button
* Provide the following repository secrets

| Key               | Description                                     |
| ----------------- | ----------------------------------------------- |
| CHEVERETO_LICENSE | Chevereto license key (*)                       |
| REGISTRY_IMAGE    | Image to be build (at), `owner/chevereto-build` |
| REGISTRY_LABEL    | `ghcr.io/owner`, `docker.io`, `quay.io`         |
| REGISTRY_PASSWORD | Password (registry access token)                |
| REGISTRY_USERNAME | Username for container registry                 |

This repo uses RedHat Actions [buildah-build](https://github.com/redhat-actions/buildah-build), [podman-login](https://github.com/redhat-actions/podman-login) and [push-to-registry](https://github.com/redhat-actions/push-to-registry).

### Custom application

By default this repository uses your Chevereto license to download the latest Chevereto release. By adding the the following repository secrets you can use your own custom application:

| Key                   | Description                                    |
| --------------------- | ---------------------------------------------- |
| REPO_APP              | Repository for the application as `owner/repo` |
| REPO_APP_ACCESS_TOKEN | Personal Access Token for the above            |

### Creating Builds

* Go to "Actions"
* Run the workflow accordingly the wanted image

The build will be available at your target container registry.

## Manual setup

```sh
docker build -t tag . -f httpd-php.Dockerfile --build-arg CHEVERETO_LICENSE=<license>
```

For custom application, put the contents in the `/chevereto` folder before building the image.

## Updating

* Add the main template repository as remote `template`

This is required just once.
  
```sh
git remote add template https://github.com/chevereto/container-builder 
```

* Fetch `template` and merge it with `main`

This will pull all updates.

```sh
git fetch template main
git merge template/main --allow-unrelated-histories
```

## Guides

* [Portainer](guides/portainer.md)
