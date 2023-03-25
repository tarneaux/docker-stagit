#!/bin/bash

BUILD_PATH=/usr/share/nginx/html

REPOS_PATH=/repos

CONFIG_PATH=/config

[[ -z "$BASEURL" ]] && echo "BASEURL not set" && exit 1


scan_repos() {
    cd $REPOS_PATH
    repos_list=$(ls -d */ .*/) # List all repos, including ones starting with a dot (hidden)
    cd -
}

scan_repos

[[ -z "$repos_list" ]] && echo "No repos found" && exit 1

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
