# sourced by catalina.sh upon start

# read the one shipped by Atlassian first
. /srv/jira/current/bin/setenv.sh

# insert our override directory to patch up files that's under JIRA
export CLASSPATH=/srv/jira/base/classes