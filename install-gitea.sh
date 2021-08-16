#!/bin/bash

set -euo pipefail

# parameters
GITHUB_TOKEN=$1
GITEA_ARCH=$2
echo "GITEA_ARCH: ${GITEA_ARCH}"


# get version
RELEASES_URL="https://api.github.com/repos/go-gitea/gitea/releases"
VERSION=$(curl --header "authorization: Bearer ${GITHUB_TOKEN}" -s "${RELEASES_URL}" | jq -r '.[].tag_name[1:] | select(contains("rc") | not)' | head -1)
echo "VERSION: ${VERSION}"

# get urls
ARCHIVE_URL="https://github.com/go-gitea/gitea/archive/v${VERSION}.tar.gz"
RELEASE_TAG_URL="https://api.github.com/repos/go-gitea/gitea/releases/tags/v${VERSION}"
URL=$(curl --header "authorization: Bearer ${GITHUB_TOKEN}" -s "${RELEASE_TAG_URL}" | jq -r '.assets[].browser_download_url' | grep "${GITEA_ARCH}" | awk 'NR==1{print $1}')

# install Gitea
mkdir -p /app/gitea
echo "Downloading Gitea app from ${URL} ..."
curl -sSLo /app/gitea/gitea "${URL}"
echo "Downloading and unpacking archive from ${ARCHIVE_URL} ..."
curl -sSL "${ARCHIVE_URL}" | \
  tar xz "gitea-${VERSION}/docker" --exclude="gitea-${VERSION}/docker/Makefile" --strip-components=3
chmod 0755 /app/gitea/gitea
echo "Done."

