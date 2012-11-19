#
#   fallback.jenkins-ci.org
#
#       functions as the fallback mirror for http://mirrors.jenkins-ci.org/ by hosting
#       all the new files (but not any old files, which are expected to be available in OSUOSL.)
#
class fallback_jenkins-ci_org {
  include apache2
  include apache2::log-rotation

  apache2::virtualhost {
    'fallback.jenkins-ci.org' :
      content => template('apache2/standard_virtualhost.erb');
  }
}
