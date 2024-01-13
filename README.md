# tailscale-serve-proxy

## Overview
`tailscale-serve-proxy` is a Docker image that integrates dockerized web
services into Tailscale as separate machines with their own hostnames.

The proxy uses the Tailscale's `serve` functionality to provide access
to the services using HTTPS (HTTPS must be enabled on your Tailnet).

## Dependencies
- [linuxserver/nginx](https://github.com/linuxserver/docker-nginx/tree/master)
- [Tailscale Docker Mod](https://tailscale.dev/blog/docker-mod-tailscale)

## Usage
Using `docker-compose` is recommended.

```
version: "3"

services:
  proxy:
    image: ghcr.io/awahlig/tailscale-serve-proxy:latest
    # hostname specifies what the name of the machine on the
    # Tailnet is going to be
    hostname: myapp
    volumes:
      # Tailscale state must be preserved.
      - ./tailscale:/var/lib/tailscale
    environment:
      # The web service to proxy.
      - TSPROXY_UPSTREAM=http://app

  # Your web service container.
  app:
    image: ...
```

After starting, visit the link from logs to add the machine to your Tailnet.

## Tailscale identity
Since all connections to the upstream service are going through the `serve`
functionality, the requests contain Tailscale
[identity headers](https://tailscale.com/s/serve-headers)
which can be used by the web service to authenticate users.

## Limitations
Because `tailscaled` is running inside the proxy container, the web
service cannot use it to connect to other devices on your Tailnet.

## License
This project is using the Apache 2.0 license.
