#!/bin/sh

if [ -z ${BUCKET_NAME} ]; then
  echo "Error: Missing required vars (Usage: BUCKET_NAME=... $0)" >&2
  exit 1
fi

# access logs won't print to stdout otherwise.
# explained here: https://github.com/docker/docker/issues/19616#issuecomment-174355979
ln -sf /proc/1/fd/1 /var/log/nginx/access.log

# required to resolve LB dns
# nginx resolver implementation fails resolution if ipv6 is not working; docker mac doesn't support ipv6
# https://github.com/docker/for-mac/issues/1432
echo resolver $(awk 'BEGIN{ORS=" "} $1=="nameserver" {print $2}' /etc/resolv.conf) "ipv6=off;" > /etc/nginx/include/resolvers.conf

exec "$@"
