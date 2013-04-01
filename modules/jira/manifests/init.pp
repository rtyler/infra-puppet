#
# Managing our customizations on our current production JIRA at https://issues.jenkins-ci.org/
#
class jira {
  file {
  [
    "/srv/jira/base",
    "/srv/jira/base/classes",
    "/srv/jira/base/conf",
    "/srv/jira/base/logs",
    "/srv/jira/base/webapps",
    "/srv/jira/base/work",
    "/srv/jira/base/temp"
  ]:
    ensure => "directory",
    owner => "jira",
    group => "jira",
    mode => 755
    ;
  "/srv/jira/base/bin/setenv.sh":
    source => "puppet:///modules/jira/setenv.sh"
    ;
  "/srv/jira/base/conf/server.xml":
    source => "puppet:///modules/jira/server.xml"
    ;
  "/srv/jira/base/conf/web.xml":
    ensure => "link",
    target => "../../current/conf/web.xml"
    ;
  }

  #
  # set up custom e-mail subject
  #
  file {
  [
    "/srv/jira/base/classes/templates",
    "/srv/jira/base/classes/templates/email",
    "/srv/jira/base/classes/templates/email/subject"
  ]:
    ensure => "directory",
    owner => "jira",
    group => "jira",
    mode => 755
    ;
  "/srv/jira/base/classes/templates/email/subject/subject.vm":
    source => "puppet:///modules/jira/subject.vm"
    ;
  }
  jira::custom_subject {
    ['issuecreated','issuecommented'] :
  }
}

define jira::custom_subject() {
  file {
  "/srv/jira/base/classes/templates/email/subject/${name}.vm":
    ensure => "link",
    target => "subject.vm"
    ;
  }
}
