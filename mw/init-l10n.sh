#!/bin/bash

set -eu -o pipefail

# INPUTS
INIT_L10N_THREADS=${INIT_L10N_THREADS:-$(getconf _NPROCESSORS_ONLN)}
INIT_L10N_LANGS=${INIT_L10N_LANGS:-all} # comma-separated

source $(dirname $0)/subs.sh

# FIXME: Add a reference that explains what this is all about.
function merge_message_list {
    local version=$1 # will be something like php-1.36.0-wmf.27
    local wikidb=$2

    echo "merge_message_list for $version (using $wikidb)"

    local nophpvers=${version:4}
    local extension_messages=/srv/mediawiki/wmf-config/ExtensionMessages-$nophpvers.php
    # This file has to exist (even if blank) before mergeMessageFileList.php can work
    touch $extension_messages

    # Need at least English lang file
    $(dirname $0)/rebuild-cdb.sh $wikidb en
    
    echo Updating $extension_messages
    local ext_list=/srv/mediawiki/wmf-config/extension-list
    local tmp=/tmp/new-ext-messages
    
    sudo -u www-data /usr/local/bin/mwscript mergeMessageFileList.php \
         --wiki=$wikidb --list-file=$ext_list --output=$tmp --quiet
    mv $tmp $extension_messages

    echo "merge_message_list done"
}

# xref mediawiki/tools/scap/scap/tasks.py:update_localization_cache()
function update_localization_cache {
    local version=$1 # will be something like php-1.36.0-wmf.27
    local wikidb=$2

    echo "Updating LocalisationCache for $version, languages: $INIT_L10N_LANGS"

    merge_message_list $version $wikidb

    $(dirname $0)/rebuild-cdb.sh $wikidb $INIT_L10N_LANGS $INIT_L10N_THREADS
}

# Required for etcd access in CommonSettings.php (used by maintenance scripts)
update-ca-certificates

for version in $(unique_wikiversions); do
    update_localization_cache $version $(representative_db_for_version $version)
done

echo $0 finished.
