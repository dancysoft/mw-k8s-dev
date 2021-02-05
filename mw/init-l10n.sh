#!/bin/bash

set -eu -o pipefail

# INPUTS
INIT_L10N_THREADS=${INIT_L10N_THREADS:-$(getconf _NPROCESSORS_ONLN)}
INIT_L10N_LANGS=${INIT_L10N_LANGS:-all} # comma-separated

source $(dirname $0)/subs.sh

# xref mediawiki/tools/scap/scap/tasks.py:update_localization_cache()
function update_localization_cache {
    local version=$1 # will be something like php-1.36.0-wmf.27
    local wikidb=$2

    local nophpvers=${version:4}
    
    echo "Updating LocalisationCache for $version, languages: $INIT_L10N_LANGS"

    $(dirname $0)/rebuild-cdb.sh $wikidb $INIT_L10N_LANGS $INIT_L10N_THREADS
}

update-ca-certificates

for version in $(unique_wikiversions); do
    update_localization_cache $version $(representative_db_for_version $version)
done

echo $0 finished.
