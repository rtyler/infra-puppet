#!/bin/sh -xe

CHECK_URL="http://mirrors.jenkins-ci.org/updates/update-center.json"

wget -O /dev/null \
  --debug \
  "${CHECK_URL}" 2>&1 | grep "X-MirrorBrain"
