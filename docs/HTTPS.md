# HTTPS

Place the certificate and private key at `https/`.

| Type        | File       |
| ----------- | ---------- |
| Certificate | `cert.pem` |
| Private key | `key.pem`  |

## Create certificate

To create a certificate using certbot:

```sh
make certbot HOSTNAME=<hostname>
```

The above command uses `certbot/certbot` for providing the files required, it will place the generated files at `https/`.

## Use HTTPS

Alter the commands to use `PROTOCOL=https`:

```sh
make up-d PROTOCOL=https HOSTNAME=<hostname>
```
