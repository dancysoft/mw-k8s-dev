#!/bin/bash

set -eu -o pipefail

function wait_for_db {
    local max_attempts=60

    echo "$(date): Waiting for DB server $DB_SERVER to become available to $DB_USER"

    for ((attempt=0; attempt<$max_attempts; attempt++)); do
        if mysql -h "$DB_SERVER" -u "$DB_USER" -p"$DB_PASS" --connect-timeout=10 </dev/null; then
            echo "$(date): DB is available"
            return
        else
            sleep 1
        fi
    done
    # If we reached here, we had no luck
    echo "$(date): DB not available.  Giving up"
    exit 1
}

# Operations below require SSL connectivity to etcd, so make sure the list of CA certs
# is up-to-date.
update-ca-certificates

wait_for_db

$(dirname $0)/init-l10n-locked.sh

cd /srv/mediawiki

for wiki in enwiki; do
    # install.php won't do anything if it finds LocalSettings.php
    rm -f php/LocalSettings.php
    echo $wiki: Performing basic db setup
    # FIXME: Factor our admin username and password
    php php/maintenance/install.php $wiki admin --pass secret123123123123 \
        --dbserver "$DB_SERVER" \
        --dbname $wiki \
        --dbuser "$DB_USER" \
        --dbpass "$DB_PASS"

    # Now that the basics are set up, use update.php with usual
    # LocalSettings.php in place.  This will create additional tables
    # that are required by enabled extensions.
    cat <<EOF > php/LocalSettings.php
<?php
require __DIR__ . "/../wmf-config/CommonSettings.php";
EOF
    echo $wiki: Update db
    mwscript maintenance/update.php --wiki=$wiki --quick
done
