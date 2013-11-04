#
# Managing our customizations on our current production Confluence at https://wiki.jenkins-ci.org/
#
class confluence {
  file {
  [
    "/srv/wiki/base",
    "/srv/wiki/base/bin",
    "/srv/wiki/base/classes",
    "/srv/wiki/base/conf",
    "/srv/wiki/base/logs",
    "/srv/wiki/base/webapps",
    "/srv/wiki/base/work",
    "/srv/wiki/base/temp"
  ]:
    ensure => "directory",
    owner => "wiki",
    group => "wiki",
    mode => 755
    ;
  "/srv/wiki/base/bin/setenv.sh":
    source => "puppet:///modules/confluence/setenv.sh"
    ;
  "/srv/wiki/base/conf/server.xml":
    source => "puppet:///modules/confluence/server.xml"
    ;
  "/srv/wiki/base/conf/web.xml":
    ensure => "link",
    target => "../../current/conf/web.xml"
    ;
  "/srv/wiki/tomcat-manager.war":
    source => "puppet:///modules/confluence/tomcat-manager.war"
    ;
  "/etc/init.d/confluence":
    # TODO: run "update-rc.d confluence defaults" when this file change
    source => "puppet:///modules/confluence/confluence.init",
    mode => 755
    ;
  }
}
