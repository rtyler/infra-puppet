#
#   boxes.jenkins-ci.org
#
#       Serves Vagrant box files for running https://github.com/jenkinsci/selenium-tests
#
class boxes_jenkins-ci_org {
  include apache2
  include apache2::log-rotation

  apache2::virtualhost {
    'boxes.jenkins-ci.org' :
      content => template('apache2/standard_virtualhost.erb');
  }
}
