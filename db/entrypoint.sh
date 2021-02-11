#!/bin/bash

set -eu -o pipefail

function wait_for_db {
    echo Waiting for mysql server to start
    
    while ! mysql </dev/null; do
	sleep 1
    done

    echo mysql server running
    
}

function setup_user {
    if [ "${DB_USER:-}" -a "${DB_PASSWORD:-}" ]; then

	wait_for_db
	
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

(setup_user) &

exec tini mysqld
