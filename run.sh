#!/bin/sh

HOSTNAME=`hostname -s`
LOGFILE="puppet.`date "+%s"`.log"
ERROR_FILE="last_run_failed"

echo "==> Preparing to run ${HOSTNAME}.pp, Ctrl-C immediately to abort"
sleep 5

rm -f ${ERROR_FILE}

echo
echo "==> Generating log file: ${LOGFILE}"

git pull --rebase >> ${LOGFILE} 2>&1 && \
 git submodule update --init >> ${LOGFILE} 2>&1 && \
 puppet apply --modulepath=modules --verbose manifests/${HOSTNAME}.pp >> ${LOGFILE} 2>&1

if [ $? -ne 0 ]; then
    touch ${ERROR_FILE}
fi
