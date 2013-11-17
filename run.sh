#!/bin/bash

LOGFILE="puppet.`date "+%s"`.log"

echo
echo "==> Generating log file: ${LOGFILE}"


# Redirect stdout ( > ) into a named pipe ( >() ) running "tee"
exec > >(tee ${LOGFILE})
# Without this, only stdout would be captured - i.e. your
# log file would not contain any error messages.
exec 2>&1

# Forcing the gems path to take priority so we can use the Puppet/Facter
# installed by gems if it's available
export PATH=/var/lib/gems/1.8/bin:$PATH

which puppet

# Make sure we have some bare minimum versions bootstrapped
if [ $? -ne 0 ]; then
  gem install puppet -v 2.7.18 --no-ri --no-rdoc
  gem install facter -v 1.6.10 --no-ri --no-rdoc
fi

which librarian-puppet

# Install librarian-puppet if we don't have it
if [ $? -ne 0 ]; then
  gem install librarian-puppet --no-ri --no-rdoc
fi

HOSTNAME=`hostname -s`
ERROR_FILE="last_run_failed"
SUCCESS_FILE="last_run_succeeded"

echo "==> Preparing to run ${HOSTNAME}.pp, Ctrl-C immediately to abort"
sleep 5

rm -f ${ERROR_FILE}

git reset --hard HEAD && \
git pull && \
 git submodule update --init && \
 librarian-puppet install && \
 puppet apply --modulepath=modules --verbose manifests/${HOSTNAME}.pp

ln -sf ${LOGFILE} puppet.latest.log

if [ $? -ne 0 ]; then
    touch ${ERROR_FILE}
else
    touch ${SUCCESS_FILE}
fi
