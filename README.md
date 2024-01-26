# Docker Remote Proxy
Quick and easy docker nginx proxy with wildcard SSL using [Traefik](https://doc.traefik.io/traefik/)

## Install

Run the following command on your server:

```shell
sh -c "$(curl -sSL https://raw.githubusercontent.com/ethercreative/docker-remote-proxy/master/install.sh)"
```

## Site Setup

Each site should have the following values set in the `.env` file:

```
COMPOSE_PROJECT_NAME=my-project
VIRTUAL_HOST=my-domain.com
```

**NOTE:** Your `COMPOSE_PROJECT_NAME` should be different to the server name

## Single Domain

In your `docker-compose.yml` file, add the following network & labels to your `web` container:

```yaml
services:
  web:
    networks:
      - proxy
      - default
    labels:
      - traefik.enable=true
      - traefik.http.routers.$COMPOSE_PROJECT_NAME.rule=Host(`$VIRTUAL_HOST`)
      - traefik.http.routers.$COMPOSE_PROJECT_NAME.tls=true
      - traefik.http.routers.$COMPOSE_PROJECT_NAME.tls.certresolver=main
networks:
  proxy:
    external: true
```

## Wildcard Domain

**Generate a DigitalOcean access token and add it to the `.env` file in the `proxy` directory.**

Uncomment the following in the `traefik.yml` file:
```yml
#      dnsChallenge:
#        provider: digitalocean
#        delayBeforeCheck: 0
```

Set your `VIRTUAL_HOST` environment variable to the wildcard domain, i.e. `VIRTUAL_HOST=*.my-domain.com` 

Add the following to your `docker-compose.yml`:

```yaml
services:
  web:
    networks:
      - proxy
      - default
    labels:
      - traefik.enable=true
      - traefik.http.routers.$COMPOSE_PROJECT_NAME.rule=PathPrefix(`/`)
      - traefik.http.routers.$COMPOSE_PROJECT_NAME.tls=true
      - traefik.http.routers.$COMPOSE_PROJECT_NAME.tls.certresolver=main
      - traefik.http.routers.$COMPOSE_PROJECT_NAME.tls.domains[0].main=$VIRTUAL_HOST
networks:
  proxy:
    external: true
```

## WWW support

In your `docker-compose.yml` file, add/modify the following labels to/in your `web` container:

```yaml
services:
  web:
    labels:
      # - ... other labels excluded for brevity ...
      - traefik.http.routers.$COMPOSE_PROJECT_NAME.rule=Host(`www.$VIRTUAL_HOST`) || Host(`$VIRTUAL_HOST`)
      - traefik.http.routers.$COMPOSE_PROJECT_NAME.middlewares=redirect-www-to-non-www@file,redirect-web-to-websecure@internal
```
This will redirect www to non-www.

Replace `redirect-www-to-non-www` with `redirect-non-www-to-www` to redirect from non-www to www.

## Development

If you want to enable the Traefik dashboard while developing, you can do so by 
setting the `api.insecure` value in `treafik.yml` to `true`. You'll then be able
to access the dashboard by going to `[server-ip]:8080` or `my-domain.com:8080`.
