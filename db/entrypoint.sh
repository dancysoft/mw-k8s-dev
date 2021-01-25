#!/bin/bash

set -eu -o pipefail

function setup_user {
    if [ "${DB_USER:-}" -a "${DB_PASSWORD:-}" ]; then
        echo Creating user $DB_USER
        mysql -e "create user '$DB_USER' identified by '$DB_PASSWORD';"

        for db in ${CREATE_DBS:-}; do
            echo Creating db $db for user $DB_USER
            mysql -e "grant all on $db.* to '$DB_USER' with grant option;"
        done
    fi
}

tail -f /var/log/mysql/error.log &

mkdir -p /run/mysqld
chown mysql: /run/mysqld

# This runs after mysqld starts (hopefully)
(sleep 2 ; setup_user ) &

exec tini mysqld
