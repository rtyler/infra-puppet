#!/bin/sh

# Forcing the gems path to take priority so we can use the Puppet/Facter
# installed by gems if it's available
export PATH=/var/lib/gems/1.8/bin:$PATH

which puppet

# Make sure we have some bare minimum versions bootstrapped
if [ $? -ne 0 ]; then
  gem install puppet -v 2.7.18 --no-ri --no-rdoc
  gem install facter -v 1.6.10 --no-ri --no-rdoc
fi

HOSTNAME=`hostname -s`
LOGFILE="puppet.`date "+%s"`.log"
ERROR_FILE="last_run_failed"
SUCCESS_FILE="last_run_succeeded"

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
else
    touch ${SUCCESS_FILE}
fi
