function realm {
    local cluster=$(cat /etc/wikimedia-cluster)

    case "$cluster" in
        dev)
            echo $cluster
            ;;
        *)
            echo production
            ;;
    esac
}

function wikiversions_json {
    local realm=$(realm)

    local prefix=/srv/mediawiki/wikiversions

    case "$realm" in
        production)
            echo $prefix.json
            ;;
        *)
            echo $prefix-$realm.json
            ;;
    esac
}

# Generates a string like: php-1.36.0-wmf.27 php-1.36.0-wmf.29
function unique_wikiversions {
    jq -r 'values[]' $(wikiversions_json) | sort -u
}

# version will be something like php-1.36.0-wmf.27
function representative_db_for_version {
    local version=$1
    
    fgrep $version $(wikiversions_json) | head -1 | sed -e 's/"//g' -e 's/://' | awk '{print $1}'
}
