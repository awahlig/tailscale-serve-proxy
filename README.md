# tailscale-serve-proxy

## Overview
`tailscale-serve-proxy` is a Docker image that adds web services from other
containers to a Tailnet as separate devices with their own hostname.

Tailscale's `serve` functionality is used to handle HTTPS traffic (HTTPS
must be enabled on your Tailnet). HTTP connections are redirected to HTTPS.

## Dependencies
- [linuxserver/nginx](https://github.com/linuxserver/docker-nginx/tree/master)
- [Tailscale Docker Mod](https://tailscale.dev/blog/docker-mod-tailscale)

## Usage
```
version: "3"

services:
  proxy:
    image: ghcr.io/awahlig/tailscale-serve-proxy
    # <hostname>.<tailnet>.ts.net
    hostname: myapp
    volumes:
      - ./tailscale:/var/lib/tailscale
    environment:
      - TSPROXY_UPSTREAM=http://app

  app:
    image: ...
```

Use the `hostname` property to define the name of the device on your Tailnet.

Visit the link from logs to add the device to your Tailnet. This state is
stored in the `tailscale` directory which is why it must be persisted.

## Tailscale identity
Since all connections to the upstream service are going through the `serve`
functionality, the requests contain Tailscale
[identity headers](https://tailscale.com/s/serve-headers)
which can be used by the service to authenticate users.

## Limitations
Because `tailscaled` is running solely inside the proxy container, the web
service cannot use it to connect to other devices on your Tailnet.

## License
This project is using the Apache 2.0 license.
