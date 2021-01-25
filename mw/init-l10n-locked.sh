#!/bin/bash

set -eu -o pipefail

INIT_L10N_CACHE_DIR=${INIT_L10N_CACHE_DIR:-/tmp/l10n-cache}

flock $INIT_L10N_CACHE_DIR $(dirname $0)/init-l10n.sh
