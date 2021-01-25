#!/bin/bash

set -eu -o pipefail

# Use the top level cache directory as the lockfile.  This means that
# if multiple pods start at the same time on a given node, only one of
# them will do the expensive work.  The others will wait for the first
# one to finish, then they'll run and find that there is no work to
# do.
flock /tmp/l10n-cache $(dirname $0)/init-l10n.sh
