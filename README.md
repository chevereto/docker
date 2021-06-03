# docker-builder

Dockerfile template project for building and distributing container images for Chevereto (ahead) releases.

## Note

Do not publish the generated image to a public access registry as it contains your licensed installation files (including your key).

🧐 Handle it with care or your license details could be stolen.

## Instructions

### GitHub Setup

- Click the [Use this template](https://github.com/chevereto/docker-builder/generate) button
- Provide the following repository secrets

| Key               | Description                                     |
| ----------------- | ----------------------------------------------- |
| CHEVERETO_LICENSE | Chevereto license key                           |
| REGISTRY_IMAGE    | Image to be build (at), `owner/chevereto-build` |
| REGISTRY_LABEL    | `ghcr.io/owner`, `docker.io`, `quay.io`         |
| REGISTRY_PASSWORD | Password (registry access token)                |
| REGISTRY_USERNAME | Username for container registry                 |

This repo uses RedHat Actions [buildah-build](https://github.com/redhat-actions/buildah-build), [podman-login](https://github.com/redhat-actions/podman-login) and [push-to-registry](https://github.com/redhat-actions/push-to-registry).

### Creating Builds

- Go to "Actions"
- Run the workflow accordingly the wanted image
