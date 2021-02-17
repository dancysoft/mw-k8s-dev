#!/bin/bash

set -eu -o pipefail

if [ $# -gt 0 ]; then
    case "$1" in
        bash)
            exec "$@"
            ;;
        *)
            echo Unhandled command \'$*\'.  Ignoring
            ;;
    esac
fi

# Ensure that any injected CA certs are known so that we can
# communicate with etcd using TLS.
update-ca-certificates

# FIXME: separate container
/usr/share/memcached/scripts/systemd-memcached-wrapper /etc/memcached.conf &

# FIXME: Use ServiceOps images
php-fpm7.2 -D
/usr/sbin/apache2ctl start

# php-fpm7.2 is now running so liveness probes will be satisfied while this potentially
# long operation runs.
$(dirname $0)/init-l10n-locked.sh

# Using bash to perform globbing
exec tini bash -- -c "tail -f /var/log/apache2/*.log"
