#!/bin/ash

defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))

envsubst "$defined_envs" \
    < /config/nginx/site-tmpls/default.conf.template \
    > /config/nginx/site-confs/default.conf
