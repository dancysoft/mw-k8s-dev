#!/bin/bash

set -e

function initialize_etcd_data {
    echo Running initialize_etcd_data:
    update-ca-certificates
    etcdctl set /conftool/v1/mediawiki-config/common/WMFMasterDatacenter '{"val": "dev"}'
    etcdctl set /conftool/v1/mediawiki-config/dev/ReadOnly '{"val": false}'
    etcdctl set /conftool/v1/mediawiki-config/dev/dbconfig < /tmp/dbconfig.json
    echo initialize_etcd_data complete
}

# This will run after etcd starts (hopefully)
# FIXME: nothing reaps this subprocess
( sleep 3 && initialize_etcd_data ) &

exec etcd \
     --data-dir /var/lib/etcd/default \
     --listen-client-urls http://127.0.0.1:4001,https://0.0.0.0:2379 \
     --advertise-client-urls https://$(hostname):2379 \
     --cert-file /tls/tls.crt \
     --key-file /tls/tls.key
