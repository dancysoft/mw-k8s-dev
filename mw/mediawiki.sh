# MediaWiki-related shell environment variables

# shellcheck disable=SC2034
MEDIAWIKI_DEPLOYMENT_DIR="/srv/mediawiki"

# shellcheck disable=SC2034
MEDIAWIKI_STAGING_DIR="/srv/mediawiki-staging"

# shellcheck disable=SC2034
MEDIAWIKI_WEB_USER="www-data"

# Members of the wikidev group are deployers, keep the things they do
# group readable/writable. Do the same for l10nupdate, which calls
# into scap.

if groups | grep -Pqw '(wikidev|l10nupdate)'; then
  umask 0002
fi
