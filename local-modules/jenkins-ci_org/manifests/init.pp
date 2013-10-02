#
#   http://jenkins-ci.org/
#
#       Our main website
#
class jenkins-ci_org {
  include apache2
  include apache2::log-rotation

  apache2::virtualhost {
    'jenkins-ci.org' :
      source => 'puppet:///modules/jenkins-ci_org/site.conf';
  }
}
