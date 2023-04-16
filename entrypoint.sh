#!/bin/bash

set -e

BUILD_PATH=/usr/share/nginx/html

REPOS_PATH=/repos

CONFIG_PATH=/config

[[ -z "$BASEURL" ]] && echo "BASEURL not set" && exit 1


scan_repos() {
    cd $REPOS_PATH
    pre_repos_list=$(find . -name .git)
    cd -
    repos_list=""
    for repo in $pre_repos_list; do
        repo=$(echo $repo | cut -d'/' -f2)
        # Filter out private repos
        if [[ -f $REPOS_PATH/$repo/.private ]]; then
            echo "Private repo: $repo"
        else
            repos_list="$repos_list $repo"
        fi
    done
}

scan_repos

[[ -z "$repos_list" ]] && echo "No repos found" && exit 1

prebuild_repo() {
    # Add some informational files for stagit from the env vars

    # owner, except if overridden by a file in the repo
    [[ $OWNER ]] && [[ -f $REPOS_PATH/$1/.git/owner ]] || echo $OWNER > $REPOS_PATH/$1/.git/owner

    # Remote url for git. Changes according to the repo name
    [[ $REMOTE ]] && echo $REMOTE/$1 > $REPOS_PATH/$1/.git/url
}

build_repo() {
    echo "Building $1"
    mkdir -p $1 # Don't fail if it already exists. This happens when we build after the first time
    echo $REPOS_PATH/$1
    (cd $repo; stagit -c /stagit.cache -u $BASEURL $REPOS_PATH/$1)
    echo "Done building $1"
}

build() {
    scan_repos
    cd $BUILD_PATH

    for repo in $repos_list; do
        prebuild_repo $repo
        build_repo $repo
    done

    stagit_index_args_list=""
    for repo in $repos_list; do
        stagit_index_args_list="$stagit_index_args_list $REPOS_PATH/$repo"
    done

    echo $stagit_index_args_list

    stagit-index $stagit_index_args_list > index.html

    # Make some symlinks to the config files and ignore errors that occur if they already exist
    ln -s $CONFIG_PATH/style.css $BUILD_PATH/style.css || :
    ln -s $CONFIG_PATH/logo.png $BUILD_PATH/logo.png || :
    ln -s $CONFIG_PATH/favicon.png $BUILD_PATH/favicon.png || :

    # We also want the configs in all of the repos
    for repo in $repos_list; do
        ln -s $CONFIG_PATH/style.css $BUILD_PATH/$repo/style.css || :
        ln -s $CONFIG_PATH/logo.png $BUILD_PATH/$repo/logo.png || :
        ln -s $CONFIG_PATH/favicon.ico $BUILD_PATH/$repo/favicon.ico || :
    done
}

build

exec nginx -g "daemon off;"
