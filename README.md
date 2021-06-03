# docker-builder

Dockerfile template project for building and distributing container images for Chevereto (ahead) releases.

## Instructions

### GitHub

- Click the "Use this template" button
- Provide the following repository secrets

| Key               | Description                                        |
| ----------------- | -------------------------------------------------- |
| CHEVERETO_LICENSE | Chevereto license key                              |
| REGISTRY_IMAGE    | Image to be build (at), `chevereto-build`          |
| REGISTRY_LABEL    | `ghcr.io/owner`, `hub.docker.com/owner`, `quay.io` |
| REGISTRY_PASSWORD | Password (registry access token)                   |
| REGISTRY_USERNAME | Username for container registry                    |

This repo uses RedHat Actions [buildah-build](https://github.com/redhat-actions/buildah-build), [podman-login](https://github.com/redhat-actions/podman-login) and [](https://github.com/redhat-actions/push-to-registry).
