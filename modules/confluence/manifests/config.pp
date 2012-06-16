class confluence::config {
  # confluence configuration files
  file {
  "/etc/confluence/WEB-INF-classes/confluence-init.properties":
    source => "puppet:///modules/confluence/confluence-init.properties"
    ;
  "/etc/confluence/conf/server.xml":
    source => "puppet:///modules/confluence/server.xml"
    ;
  "/srv/wiki/.my.cnf":
    source => "puppet:///modules/confluence/my.cnf"
    ;
  "/srv/wiki/convert-to-innodb.sh":
    source => "puppet:///modules/confluence/convert-to-innodb.sh"
    ;

  "/srv/wiki/tail-log.sh":
    source => "puppet:///modules/confluence/tail-log.sh"
  }

  # needed to run 'make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/apache2/snakeoil.crt'
  # to get the snake-oil certificate generated
  exec {
  "/etc/apache2/server.crt":
    command => "make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/apache2/server.crt",
    unless => "test -f /etc/apache2/server.crt",
  }

  apache2::module {
    ['ssl', 'proxy', 'proxy_http'] : ;
  }

  apache2::virtualhost {
    'wiki2.jenkins-ci.org' :
    source => 'puppet:///modules/confluence/wiki.jenkins-ci.org';
  }

  # TODO: stage https key files


}
