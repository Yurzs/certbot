# certbot:haproxy

A simple certbot image for usage with haproxy in docker-compose.
On cert renewal, the cert and key are combined into a single file and copied
to running haproxy container using haproxy runtime API. 

On container restart the cert is loaded from the combined file.

## Usage

To use this image, you need to mount the `/etc/letsencrypt` directory from the
certbot container to the haproxy container. You also need to mount the directory
where the combined cert and key will be stored in the haproxy container.

In your haproxy configuration, you need to use `ssl crt-list` to load the cert and key.
Folder with crts lists should be mounted to haproxy and certbot container under the same location.

### Example

You need to enable runtime API in your haproxy configuration and specify the location 
of the combined cert and key:

```haproxy
global
    stats socket :9999 level admin expose-fd listeners

frontend https
    bind *:443 ssl crt-list /usr/local/etc/haproxy/crts/crt.list
    ...
```

Use `/usr/local/etc/haproxy/crts/crt.list` for all frontends.
Certs are smartly picked by domain name in each frontend.

If you don't have a cert container is building one on entrypoint.
It's located at `/etc/letsencrypt/dummy.pem` and you can use it in your haproxy configuration.

Example `docker-compose.yml`:

```yaml

services:
  haproxy:
    image: haproxy:alpine
    ports:
      - "443:443"
    volumes:
      - /etc/letsencrypt:/etc/letsencrypt
      - $PWD/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro
      - $PWD/crts:/usr/local/etc/haproxy/crts/

  certbot:
    image: ghcr.io/yurzs/certbot:master
    volumes:
      - /etc/letsencrypt:/etc/letsencrypt
      - $PWD/crts:/usr/local/etc/haproxy/crts/
```

If your container with haproxy is named not `haproxy` you need to specify env variable to 
certbot container:

```yaml
  certbot:
    environment:
      HAPROXY_CONTAINER: <haproxy_container_name>
```

## Manually combining cert and key

If you want to manually combine the cert and key, you can use the following command on 
running certbot container:

```bash
docker compose exec -it -e CERTBOT_DOMAIN=<your_domain> <cerbot_container_name> haproxy-hook
```
