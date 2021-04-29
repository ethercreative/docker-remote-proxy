# Docker Remote Proxy
Quick and easy docker nginx proxy with wildcard SSL using [Traefik](https://doc.traefik.io/traefik/)

## Install

Run the following command on your server:

```shell
sh -c "$(curl -sSL https://raw.githubusercontent.com/ethercreative/docker-remote-proxy/master/install.sh)"
```

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
      - traefik.http.routers.my-unique-container-name.rule=Host(`my-domain.here`)
      - traefik.http.routers.my-unique-container-name.tls=true
      - traefik.http.routers.my-unique-container-name.tls.certresolver=main
networks:
  proxy:
    external: true
```

## Wildcard Domain

Generate a DigitalOcean access token and add it to the `.env` file in the `proxy` directory.

Add the following to your `docker-compose.yml`:

```yaml
services:
  web:
    networks:
      - proxy
      - default
    labels:
      - traefik.enable=true
      - traefik.http.routers.my-unique-container-name.rule=PathPrefix(`/`)
      - traefik.http.routers.my-unique-container-name.tls=true
      - traefik.http.routers.my-unique-container-name.tls.certresolver=main
      - traefik.http.routers.my-unique-container-name.tls.domains[0].main=*.my-domain.here
networks:
  proxy:
    external: true
```
