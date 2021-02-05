#!/bin/bash

set -eu -o pipefail

source $(dirname $0)/subs.sh

# xref mediawiki/tools/scap/scap/tasks.py:update_localization_cache()
# FIXME: Add a reference that explains wtf this is all about.
function merge_message_list {
    local version=$1 # will be something like php-1.36.0-wmf.27
    local wikidb=$2

    # FIXME: Verify that the db isn't actually used, in which case we
    # can just pass aawiki (or some dummy string that clarifies that
    # the db is not used)
    echo "merge_message_list for $version (using $wikidb)"

    local priv=/srv/mediawiki/private/PrivateSettings.php
    touch $priv

    local nophpvers=${version:4}
    local extension_messages=/srv/mediawiki/wmf-config/ExtensionMessages-$nophpvers.php
    # This file has to exist (even if blank) before mergeMessageFileList.php can work
    touch $extension_messages

    # Need at least English lang file
    $(dirname $0)/rebuild-cdb.sh $wikidb en
    
    echo Updating $extension_messages
    local ext_list=/srv/mediawiki/wmf-config/extension-list
    
    sudo -u www-data env MW_NO_ETCD=1 /usr/local/bin/mwscript mergeMessageFileList.php --wiki=$wikidb --list-file=$ext_list --output=/tmp/new-ext-messages --quiet
    mv /tmp/new-ext-messages $extension_messages

    rm $priv

    # FIXME: Delete file(s) created by rebuild-cdb.sh to keep the image clean
}

for version in $(unique_wikiversions); do
    merge_message_list $version $(representative_db_for_version $version)
done
