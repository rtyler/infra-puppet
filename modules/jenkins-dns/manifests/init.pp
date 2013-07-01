
class jenkins-dns {
  $jenkins_dns_server = '140.211.15.121'

  exec {
    'add jenkins dns server' :
      unless  => "grep '${jenkins_dns_server}' /etc/resolv.conf",
      path    => ['/bin', '/usr/bin'],
      user    => root,
      command => "echo 'nameserver ${jenkins_dns_server}' >> /etc/resolv.conf";
}
}
# vim: shiftwidth=2 expandtab tabstop=2
