# Docker Stack For [Snipe-IT](https://github.com/snipe/snipe-it)

![Docker Image Size (latest)](https://img.shields.io/docker/image-size/zeigren/snipe-it/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/zeigren/snipe-it)

## Links

### [Docker Hub](https://hub.docker.com/r/zeigren/snipe-it)

### [ghcr.io](https://ghcr.io/zeigren/snipe-it-docker)

### [GitHub](https://github.com/Zeigren/snipe-it-docker)

## Tags

- latest
- v5.1.8

## Stack

- PHP 7.4-fpm-alpine - Snipe-IT
- Caddy or NGINX - web server
- MariaDB - database
- Redis Alpine - cache

## Usage

Use [Docker Compose](https://docs.docker.com/compose/) or [Docker Swarm](https://docs.docker.com/engine/swarm/) to deploy. Containers are available from both Docker Hub and the GitHub Container Registry.

There are examples for using either [Caddy](https://caddyserver.com/) or [NGINX](https://www.nginx.com/) as the web server and examples for using Caddy, NGINX, or [Traefik](https://traefik.io/traefik/) for HTTPS (the Traefik example also includes using it as a reverse proxy). The NGINX examples are in the nginx folder.

## Recommendations

I recommend using Caddy as the web server and either have it handle HTTPS or pair it with Traefik as they both have native [ACME](https://en.wikipedia.org/wiki/Automated_Certificate_Management_Environment) support for automatically getting HTTPS certificates from [Let's Encrypt](https://letsencrypt.org/) or will create self signed certificates for local use.

If you can I also recommend using [Docker Swarm](https://docs.docker.com/engine/swarm/) over [Docker Compose](https://docs.docker.com/compose/) as it supports [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/) and [Docker Configs](https://docs.docker.com/engine/swarm/configs/).

If Caddy doesn't work for you or you are chasing performance then checkout the NGINX examples. I haven't done any performance testing but NGINX has a lot of configurability which may let you squeeze out better performance if you have a lot of users, also check the performance section below.

## Configuration

Configuration consists of setting environment variables in the `.yml` files. More environment variables for configuring [Snipe-IT](https://snipe-it.readme.io/docs/server-configuration) and PHP can be found in `docker-entrypoint.sh` and for Caddy in `snipe-it-caddyfile`.

Setting the `DOMAIN` variable changes whether Caddy uses HTTP, HTTPS with a self signed certificate, or HTTPS with a certificate from Let's Encrypt or ZeroSSL. Check the Caddy [documentation](https://caddyserver.com/docs/automatic-https) for more info.

### [Docker Swarm](https://docs.docker.com/engine/swarm/)

I personally use this with [Traefik](https://traefik.io/traefik/) as a reverse proxy, I've included an example `traefik.yml` but it's not necessary.

You'll need to create the appropriate [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/) and [Docker Configs](https://docs.docker.com/engine/swarm/configs/).

Run with `docker stack deploy --compose-file docker-swarm.yml snipe-it`

### [Docker Compose](https://docs.docker.com/compose/)

Run with `docker-compose up -d`. View using `127.0.0.1:9080`.

### File Uploads

Set the `POST_MAX_SIZE`, `UPLOAD_MAX_FILESIZE`, and `MEMORY_LIMIT` variables to whatever you want the max file upload size to be (`MEMORY_LIMIT` should at least be 128M). Default is 10M.

### Performance Tuning

The web servers set the relevant HTTP headers to have browsers cache as much as they can for as long as they can while requiring browsers to check if those files have changed, this is to get the benefit of caching without having to deal with the caches potentially serving old content. If content doesn't change that often or can be invalidated in another way then this behavior can be changed to reduce the number of requests.

By default I set PHP to scale up child processes based on demand, this is great for a low resource and light usage environment but setting this to be dynamic or static will yield better performance. Check the PHP Configuration section in `docker-entrypoint.sh` for some tuning options to set and/or research.

## File Permissions

If using docker volumes and the default user (`www-data` with a UID and GID of `82`) you shouldn't need to do anything. However if you run the container as a different [user](https://docs.docker.com/compose/compose-file/compose-file-v3/#domainname-hostname-ipc-mac_address-privileged-read_only-shm_size-stdin_open-tty-user-working_dir) or have any permissions issues you may need to change the permissions for `/var/www/snipeit`.

One way to change the permissions would be to the change the [entrypoint](https://docs.docker.com/compose/compose-file/compose-file-v3/#entrypoint) for the Snipe-IT container in the `.yml` file to `entrypoint: sleep 900m` and attach to the container as `root` and run `chown -R www-data:www-data /var/www/snipeit`, or instead of attaching to the container you could run `docker exec -it --user root SNIPEIT_CONTAINER /bin/sh -c "chown -R www-data:www-data /var/www/snipeit"`
