# Setup

* Clone the repository

```sh
git clone https://github.com/chevereto/docker.git
```

## Namespace

💡 To use namespace pass the `NAMESPACE=<namespace>` option. Default namespace is `chevereto`.

Using namespaces is recommended for multi-host setup as rather than passing all the command options, you define a file which will load all these variables.

### Creating a namespace

Run `make namespace` for automatic create a namespace. For example, to create the "nasa" namespace:

```sh
make namespace NAMESPACE=nasa HOSTNAME=photos.nasa.gov
```

This will create `./namespace/nasa` with the minimum namespaced scoped variables required:

```plain
HOSTNAME=photos.nasa.govm
ENCRYPTION_KEY=22AkowLRYAjrgCspcwsphjWybzZEIw4rBKhzKLk/50g=
```

💡 The `ENCRYPTION_KEY` is automatic generated if not provided.

## Custom application

Put the contents of your custom Chevereto based application in the `/chevereto` folder before [building](BUILDING.md) the image.
