# tailscale-serve-proxy

## Overview
`tailscale-serve-proxy` is a Docker image that integrates dockerized web
services into Tailscale as separate machines with their own hostnames.

The proxy uses the Tailscale's `serve` functionality to provide HTTPS
termination. Note that HTTPS must be enabled on your Tailnet.
Plain HTTP requests are redirected to HTTPS.

## Dependencies
- [linuxserver/nginx](https://github.com/linuxserver/docker-nginx/tree/master)
- [Tailscale Docker Mod](https://tailscale.dev/blog/docker-mod-tailscale)

## Usage
Using `docker-compose` is recommended.

```yaml
version: "3"

services:
  proxy:
    image: ghcr.io/awahlig/tailscale-serve-proxy:latest
    volumes:
      # Tailscale state must be preserved.
      - ./tailscale:/var/lib/tailscale
    environment:
      # Name of the machine on the Tailnet.
      - TAILSCALE_HOSTNAME=myapp
      # URL of the web service to proxy.
      - TSPROXY_UPSTREAM=http://app

  # Your web service container.
  app:
    image: ...
```

After starting, visit the link from logs to add the machine to your Tailnet.

## Tailscale identity
The `serve` functionality also means that requests sent to the backend conatin
Tailscale [identity headers](https://tailscale.com/s/serve-headers)
which can be used to identify Tailscale users using the service.

## Limitations
Because `tailscaled` is running inside the proxy container, the web
service cannot use it to connect to other machines on your Tailnet.

## License
This project is using the Apache 2.0 license.
