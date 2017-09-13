#!/usr/bin/env bash

# govendordate.sh
# 2017-09-07
#
# This script helps setup govendor with vendor packages with commit older than
# the provided date.
# An older commit may be selected if the project uses tags and a tag older
# than the provided date is available.


# get_repo_url returns the git repository path from a golang import path
function get_repo_url() {
    repo_url=$(curl --silent https://${1}?go-get=1 | sed -n 's/.*"go-import" content=".* git \(.*\)">.*/\1/p')
    echo $repo_url
}

## check for arguments
if [ -z "$1" ]; then
    cat << EOF
Usage: $(basename $0) DATE

Where:
    DATE is latest date of the packages needed in YYYY/MM/DD format
EOF
    exit 1
fi

DATE="$1"

## checking for govendor
command -v govendor > /dev/null 2>&1 || { echo "govendor not found" >&2; exit 1; }

## `govendor init` if needed
test ! -f vendor/vendor.json && govendor init

## Getting the list of external packages needed
PACKAGES=$(govendor list --no-status +external +missing)

## For each package; the most appropriate hashes are identified as follows:
##     1. try to get a tag version prior to the provided date
##     2. get the latest hash prior to  the provided date
PACKAGE_VERSIONS=""


# Creating a temporary directory
CWD=$(pwd)
tdir=$(mktemp -d)

for PACKAGE in ${PACKAGES}; do
    cd $tdir

    REPO_URL=$(get_repo_url ${PACKAGE})
    echo ${REPO_URL}
    git clone --quiet ${REPO_URL}
    # basename works fine on $REPO_URL
    cd $(basename ${REPO_URL} .git)

    # Checking if the projects uses tags
    tag_count=$(git tag | wc -l)
    found_version="false"
    if [ "$tag_count" != "0" ]; then
        echo "INFO: ${PACKAGE} use tags. Trying to find the latest tag before ${DATE}."
        package_meta=$(git log --before=$DATE --oneline --decorate --tags --no-walk --pretty="%H,%d, %cI" | head -n 1)
        if [ -n "${package_meta}" ]; then
            # package_meta is the commit we are looking for
            # append to the list PACKAGE_VERSIONS
            echo "INFO: Found tag version for ${PACKAGE}:"
            echo "${PACKAGE}, ${package_meta}"
            PACKAGE_VERSIONS="${PACKAGE_VERSIONS} ${PACKAGE}@=$(echo ${package_meta} | sed -n 's/.*tag: \(.*\)).*/\1/p')"
            found_version="true"
        else
            echo "INFO: No tag version found for ${PACKAGE} before ${DATE}."
        fi
    fi
    if [ "${found_version}" == "false" ]; then
        echo "INFO: Trying to find the latest commit for ${PACKAGE} before ${DATE}."
        package_meta=$(git log --before=$DATE --oneline --decorate --pretty="%H, %cI" | head -n 1)
        if [ -z "${package_meta}" ]; then
            # there is no commit before $DATE
            # error out and stop further processing
            echo "ERROR: Could not find a commit for ${PACKAGE} before ${DATE}"
            exit 10
        fi
        # package_meta contains the commit we want
        echo "INFO: Found commit for ${PACKAGE}:"
        echo "${PACKAGE}, ${package_meta}"
        PACKAGE_VERSIONS="${PACKAGE_VERSIONS} ${PACKAGE}@$(echo ${package_meta} | cut -f 1 -d ,)"
    fi

    echo ""
    echo ""
done

cd "${CWD}"
echo ""
echo ""

## Deleting the temporary directory
rm -rf "${tdir}"

## govendor fetch each of the versioned packages
for PKG in ${PACKAGE_VERSIONS}; do
    govendor fetch "${PKG}"
done
