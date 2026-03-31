#!/bin/bash
set -e

envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/nginx.conf > /etc/nginx/nginx.conf

exec nginx -g "daemon off;"
