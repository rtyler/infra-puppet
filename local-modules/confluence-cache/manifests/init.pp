#
# Static cache frontend for Confluence
#
class confluence-cache {
  include nginx
  include apache2

  # to co-exist with others, incoming HTTP requests hit Apache first
  apache2::virtualhost {
    'wiki.jenkins-ci.org' :
      source => 'puppet:///modules/confluence-cache/site.conf';
  }

  # then nginx handles cache
  nginx::virtualhost {
    'confluence-cache' :
      source => 'puppet:///modules/confluence-cache/confluence-cache.conf';
  }

  # then it defers to Confluence, which is managed outside Puppet

  # this file was used during test deployment
  file {
    '/etc/apache2/sites-enabled/wiki-fast.jenkins-ci.org':
      ensure => absent;
  }
}
