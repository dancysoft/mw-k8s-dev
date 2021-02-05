#!/bin/bash

# Rebuild some or all CDB l10n files if needed

set -eu -o pipefail

function usage {
    cat <<EOF
Usage: $0 WIKIDB LANG [ THREADS ]

LANG may be a comma-separated list of language codes, or "all"

THREADS is the number of threads to use to perform the operation.
The default value is the number of CPUs on the system.

EOF

    exit 1
}

if [ $# -lt 2 -o $# -gt 3 ]; then
    usage
fi

wikidb=$1
lang=$2
threads=${3:-$(getconf _NPROCESSORS_ONLN)}

if [ "$lang" = "all" ]; then
    lang=
else
    lang="--lang $lang"
fi

sudo -u www-data \
     env MW_NO_ETCD=1 \
     /usr/local/bin/mwscript rebuildLocalisationCache.php \
     --wiki=$wikidb \
     --store-class=LCStoreCDB \
     --threads=$threads \
     --no-clear-message-blob-store \
     $lang
