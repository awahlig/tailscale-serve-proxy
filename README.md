# tailscale-serve-proxy

## Overview
`tailscale-serve-proxy` is a Docker image that integrates dockerized web
services into Tailscale as separate machines with their own hostnames.

The proxy uses the Tailscale's `serve` functionality to provide HTTPS
termination. Note that HTTPS must be enabled on your Tailnet.
Plain HTTP requests are redirected to HTTPS.

## Dependencies
- [Tailscale Docker Mod](https://github.com/tailscale-dev/docker-mod)
- [linuxserver/nginx](https://github.com/linuxserver/docker-nginx/tree/master)

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

See the
[Tailscale Docker Mod](https://github.com/tailscale-dev/docker-mod#configuration)
documentation for a full list of supported variables.

After starting, visit the link from the container logs to add the machine
to your Tailnet.

## Tailscale identity
Using the `serve` functionality also means that requests sent to the backend
conatin Tailscale [identity headers](https://tailscale.com/s/serve-headers).
These can be used by the backend to identify Tailscale users visiting the
service.

## Limitations
Because tailscale is running inside the proxy container, the backend cannot
use it to connect to other machines on the Tailnet.

## License
This project is using the Apache 2.0 license.
