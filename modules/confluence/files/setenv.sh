# sourced by catalina.sh upon start

# read the one shipped by Atlassian first
. /srv/wiki/current/bin/setenv.sh

export JAVA_OPTS="-Xms768m -Xmx768m -XX:MaxPermSize=256m $JAVA_OPTS -Djava.awt.headless=true "
