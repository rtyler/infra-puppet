#!/bin/sh

HOSTNAME=`hostname -s`
LOGFILE="puppet.`date "+%s"`.log"

echo "==> Preparing to run ${HOSTNAME}.pp, Ctrl-C immediately to abort"
sleep 5

echo
echo "==> Generating log file: ${LOGFILE}"

git pull --rebase >> ${LOGFILE} 2>&1 && puppet apply --modulepath=modules --verbose manifests/${HOSTNAME}.pp >> ${LOGFILE} 2>&1
