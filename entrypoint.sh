#!/bin/bash

BUILD_PATH=/usr/share/nginx/html

REPOS_PATH=/repos


-z "$BASEURL" && echo "BASEURL not set" && exit 1



mkdir $BUILD_PATH


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


exec nginx -g "daemon off;"
