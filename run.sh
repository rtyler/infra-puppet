#!/bin/sh

HOSTNAME=`hostname -s`

echo "==> Preparing to run ${HOSTNAME}.pp, Ctrl-C immediately to abort"
sleep 5

git pull --rebase && puppet apply --modulepath=modules --verbose manifests/${HOSTNAME}.pp
