#!/bin/bash

set -eou pipefail

docker run --rm sebastianalbers/gitea:latest /app/gitea/gitea --version > version.tmp
sed '/^[gG]itea version/!{q1}; s/^[gG]itea version \([0-9\.]*\(\|\+\dev\)\)\( \|-\).*/\1/' version.tmp
rm version.tmp
