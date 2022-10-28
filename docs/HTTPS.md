# HTTPS

The certificate and private key will be taken from:

| Type        | File             |
| ----------- | ---------------- |
| Certificate | `https/cert.pem` |
| Private key | `https/key.pem`  |

## Create certificate

To create HTTPS certificate:

* Spawn HTTP website (needed for Certbot validation)
* Run Certbot:

```sh
make certbot HOSTNAME=<hostname>
```

The above command uses `certbot/certbot` for providing the files required, it will place generated files at `https/`. Once done, re-spawn website with `PROTOCOL=https`.

## Toggle HTTPS use

By default the project uses `PROTOCOL=http`. Alter to `PROTOCOL=https` to use HTTPS:

```sh
make up-d PROTOCOL=https HOSTNAME=<hostname>
```
