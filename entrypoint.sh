#!/bin/bash

BUILD_PATH=/usr/share/nginx/html

REPOS_PATH=/repos

CONFIG_PATH=/config

[[ -z "$BASEURL" ]] && echo "BASEURL not set" && exit 1

cd $REPOS_PATH
repos_list=$(ls -d *)
cd -

cd $BUILD_PATH

for repo in $repos_list; do
    echo "Building $repo"
    mkdir $repo
    echo $REPOS_PATH/$repo
    (cd $repo; stagit -u $BASEURL $REPOS_PATH/$repo)
    echo "Done building $repo"
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

exec nginx -g "daemon off;"
