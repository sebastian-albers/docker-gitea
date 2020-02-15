#!/bin/bash
docker run sebastianalbers/gitea:latest-$1 /app/gitea/gitea --version |
  sed '/^Gitea version/!{q1}; s/^Gitea version \([0-9\.]*\) .*$/\1/'

