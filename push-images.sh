#!/bin/bash

set -eou pipefail

version=$(./read-version.sh)
current_version=
tags=

# split version and create tags, e.g. 1.2.3.4 => '1', '1.2', '1.2.3', '1.2.3.4'
IFS='.' read -ra PART <<< "$version"
for i in "${PART[@]}"; do
  if [ -z "${current_version}" ] ; then
    current_version="${i}"
  else
    current_version="${current_version}.${i}"
  fi
  if [ -z "${tags}" ] ; then
    tags="${current_version}"
  else
    tags="${tags} ${current_version}"
  fi
done

# push latest tag
docker push "sebastianalbers/gitea:latest"

# push all version tags
for tag in $tags ; do
  docker tag "sebastianalbers/gitea:latest" "sebastianalbers/gitea:${tag}"
  docker push "sebastianalbers/gitea:${tag}"
done
