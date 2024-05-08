# Commands

## Instances

## Deploy

Use this when needing to deploy a brand new instance. It will create the NAMESPACE and run CloudFlare related commands (if needed).

```sh
make deploy NAMESPACE=yourproject ADMIN_EMAIL=admin@domain.tld
```

## Update

Use this to update all instances to a newly tagged image.

```sh
make update
```

## Install

Use this to install Chevereto from the command line.

```sh
make install NAMESPACE=yourproject ADMIN_USER=admin ADMIN_EMAIL=admin@domain.tld ADMIN_PASSWORD=mypassword
```

## Destroy

Use this when needing to destroy an instance.

This will run [cloudflare--delete](CLOUDFLARE.md#delete-cname-record), [down--volumes](DOCKER-COMPOSE.md#down-volumes) and remove the [NAMESPACE](NAMESPACE.md).

```sh
make destroy NAMESPACE=yourproject
```

## Proxy

### Proxy create

Run this command to create the ingress proxy, which will create the network and containers.

```sh
make proxy
```

### Proxy view

Run this command to view the ingress proxy configuration.

```sh
make proxy--view
```

### Proxy remove

Run this command if you need to destroy the ingress proxy, which will remove the network and containers.

```sh
make proxy--remove
```
