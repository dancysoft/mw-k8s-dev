#!/bin/bash

set -eu -o pipefail

# FIXME:
# * hardcoded /srv/mediawiki/wikiversions-dev.json

function _call_rebuildLocalisationCache {
    local wikidb=$1
    local cache_dir=$2
    local lang=${3:-}
    local force=${4:-}

    if [ -z "$lang" -o "$lang" = "all" ]; then
        lang=
    elif [ "$lang" ]; then
        lang="--lang $lang"
    fi

    if [ "$force" ]; then
        force="--force"
    fi

    local ncpus

    if [ "${THREADS:-}" ]; then
        ncpus=$THREADS
    else
        ncpus=$(getconf _NPROCESSORS_ONLN)
    fi

    echo "rebuildLocalisationCache.php with $ncpus thread(s)"
    
    time sudo -u www-data \
         /usr/local/bin/mwscript rebuildLocalisationCache.php \
         --wiki=$wikidb \
         --store-class=LCStoreCDB \
         --threads=$ncpus \
         --no-clear-message-blob-store \
         $lang \
         $force
}

# xref mediawiki/tools/scap/scap/tasks.py:update_localization_cache()
function update_localization_cache {
    local version=$1 # (without php- prefix)
    local wikidb=$2

    echo "update_localization_cache for $version (using $wikidb)"
    
    local extension_messages=/srv/mediawiki/wmf-config/ExtensionMessages-$version.php
    touch $extension_messages

    #local cache_dir=/srv/mediawiki/php-$version/cache/l10n
    local cache_dir=/tmp/l10n-cache/$version
    local force_rebuild=

    echo cache_dir: $cache_dir
    sudo -u www-data mkdir -p $cache_dir

    if [ ! -f $cache_dir/l10n_cache-en.cdb ]; then
        # mergeMessageFileList.php needs a l10n file
        echo Bootstrapping l10n cache for $version
        _call_rebuildLocalisationCache $wikidb $cache_dir en
        # Force subsequent cache rebuild to overwrite bootstrap version
        force_rebuild=true
    fi

    echo Updating $extension_messages
    local ext_list=/srv/mediawiki/wmf-config/extension-list

    sudo -u www-data /usr/local/bin/mwscript mergeMessageFileList.php --wiki=$wikidb --list-file=$ext_list --output=/tmp/new-ext-messages --quiet
    mv /tmp/new-ext-messages $extension_messages

    # Build the CDB files
    echo "Updating LocalisationCache for $version, languages: $MW_LANGS"

    _call_rebuildLocalisationCache $wikidb $cache_dir $MW_LANGS $force_rebuild
}


function unique_wikiversions {
    sed -e '/^{/d' -e '/^}/d' -e 's/,$//' -e 's/"//g' -e 's/php-//' /srv/mediawiki/wikiversions-dev.json | awk '{print $2}' | sort -u
}

function representative_db_for_version {
    local version=$1
    
    fgrep php-$version /srv/mediawiki/wikiversions-dev.json  | head -1 | sed -e 's/"//g' -e 's/://' | awk '{print $1}'
}

update-ca-certificates

for version in $(unique_wikiversions); do
    update_localization_cache $version $(representative_db_for_version $version)
done
