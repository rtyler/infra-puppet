#
# Managing our customizations on our current production Confluence at https://wiki.jenkins-ci.org/
#
class confluence {
  file {
  "/etc/init.d/confluence":
    # TODO: run "update-rc.d confluence defaults" when this file change
    source => "puppet:///modules/confluence/confluence.init",
    mode => 755
  }
}
