# Logs

```sh
make <command> <options>
```

## Options

* NAMESPACE=yourproject
* SERVICE=php
* VERSION=4.1

(*) For `SERVICE` you can use `php` and `database` respectively to get the logs for the PHP Apache and the MariaDB database.

## Access log

```sh
make log-access NAMESPACE=yourproject
make log-access NAMESPACE=yourproject SERVICE=database
```

## Error log

```sh
make log-error NAMESPACE=yourproject
make log-error NAMESPACE=yourproject SERVICE=database
```
