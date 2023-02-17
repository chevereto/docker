# Namespace

Using namespaces is recommended for multi-host setup as rather than passing all the command options you define a file which will load all these variables for each website.

💡 To use namespace pass the `NAMESPACE=<namespace>` option on `make` commands.

## Creating a namespace

Run `make namespace` to create a namespace.

Required options:

* NAMESPACE=chevereto
* HOSTNAME=localhost

For example, to create the `nasa` namespace for `photos.nasa.gov`:

```sh
make namespace NAMESPACE=nasa HOSTNAME=photos.nasa.gov
```

This will create `./namespace/nasa` with the minimum namespaced scoped variables required:

```plain
HOSTNAME=photos.nasa.gov
ENCRYPTION_KEY=22AkowLRYAjrgCspcwsphjWybzZEIw4rBKhzKLk/50g=
```

🔑 The `ENCRYPTION_KEY` is automatic generated if option `ENCRYPTION_KEY` is not provided.
