#!/bin/bash

set -eu

(sleep 2; tail -f /var/log/nginx/*.log ) &

exec nginx -g "daemon off;"
