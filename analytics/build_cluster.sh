#!/bin/bash

if [ -z "$1" ]; then
  echo Usage: $0 \<manifest url\>
  echo e.g. $0 http://172.23.120.24/builds/latestbuilds/couchbase-server/spock/2604/couchbase-server-5.0.0-2604-manifest.xml
  exit 1
fi

(
  curl $1 | awk -v regex="RELEASE.*spock" -v count="3" '$0 ~ regex { skip=count; next } --skip >= 0 { next } 1' \
      | awk -v regex="name=\"tlm\"" -v count="4" '$0 ~ regex { skip=count; next } --skip >= 0 { next } 1' \
      | grep -v 'name="ns_server"' | sed '$d'
  echo
  echo '  <!-- Analytics Additions -->'
  cat cluster_part.xml | sed 1,2d
  echo "<!-- based on $1 -->"

) | sed 's/[[:space:]]*$//' > cluster.xml

git diff cluster.xml