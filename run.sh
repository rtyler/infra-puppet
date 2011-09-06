#!/bin/sh

HOSTNAME=`hostname -s`
LOGFILE="puppet.`date "+%s"`.log"

echo "==> Preparing to run ${HOSTNAME}.pp, Ctrl-C immediately to abort"
sleep 5

echo
echo "==> Generating log file: ${LOGFILE}"

exec &> $LOGFILE


git pull --rebase && puppet apply --modulepath=modules --verbose manifests/${HOSTNAME}.pp
