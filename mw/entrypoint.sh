#!/bin/bash

set -eu -o pipefail

# Ensure that any injected CA certs are known so that we can
# communicate with etcd using TLS.
update-ca-certificates

sudo -u mwdeploy scap wikiversions-compile

# FIXME: separate container
/usr/share/memcached/scripts/systemd-memcached-wrapper /etc/memcached.conf &

# FIXME: Use ServiceOps images
php-fpm7.2 -D
/usr/sbin/apache2ctl start
exec tail -f /var/log/apache2/*.log
