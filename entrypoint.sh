#!/bin/bash

BUILD_PATH=/usr/share/nginx/html

REPOS_PATH=/repos

CONFIG_PATH=/config

[[ -z "$BASEURL" ]] && echo "BASEURL not set" && exit 1


scan_repos() {
    cd $REPOS_PATH
    pre_repos_list=$(ls -d */ .*/) # List all repos, including ones starting with a dot (hidden)
    cd -
    repos_list=""
    for repo in $pre_repos_list; do
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
    mkdir $1
    echo $REPOS_PATH/$1
    (cd $repo; stagit -u $BASEURL $REPOS_PATH/$1)
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

    ln -s $CONFIG_PATH/style.css $BUILD_PATH/style.css
    ln -s $CONFIG_PATH/logo.png $BUILD_PATH/logo.png
    ln -s $CONFIG_PATH/favicon.ico $BUILD_PATH/favicon.ico

    # We also want the configs in all of the repos
    for repo in $repos_list; do
        ln -s $CONFIG_PATH/style.css $BUILD_PATH/$repo/style.css
        ln -s $CONFIG_PATH/logo.png $BUILD_PATH/$repo/logo.png
        ln -s $CONFIG_PATH/favicon.ico $BUILD_PATH/$repo/favicon.ico
    done
}

build

exec nginx -g "daemon off;"
