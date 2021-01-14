#!/bin/bash

set -eu -o pipefail

function setup_user {
    mysql -e "create user 'wikiuser' identified by 'password';"
    for db in aawiki enwiki labtestwiki testwiki testwikidatawiki  metawiki; do
        mysql -e "grant all on $db.* to 'wikiuser' with grant option;"
    done
}

tail -f /var/log/mysql/error.log &

mkdir -p /run/mysqld
chown mysql: /run/mysqld

# This runs after mysqld starts (hopefully)
# FIXME: Nothing reaps this.
(sleep 2 ; setup_user ) &

# FIXME: control-c doesn't terminate this
exec mysqld

