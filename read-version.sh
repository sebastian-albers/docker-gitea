#!/bin/bash

set -eou pipefail

docker run --rm sebastianalbers/gitea:latest-$1 /app/gitea/gitea --version > version.tmp
sed '/^Gitea version/!{q1}; s/^Gitea version \([0-9\.]*\(\|\+\dev\)\)\( \|-\).*/\1/' version.tmp
rm version.tmp
