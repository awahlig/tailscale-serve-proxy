FROM lscr.io/linuxserver/nginx:latest

ENV DOCKER_MODS ghcr.io/tailscale-dev/docker-mod:main

ENV TAILSCALE_SERVE_MODE https
ENV TAILSCALE_SERVE_PORT 443
ENV TAILSCALE_STATE_DIR /var/lib/tailscale

COPY default.conf.template /config/nginx/site-tmpls/

ENV TSPROXY_UPSTREAM http://localhost

RUN apk add envsubst

COPY generate_nginx_config.sh /custom-cont-init.d/
RUN chmod +x /custom-cont-init.d/generate_nginx_config.sh
