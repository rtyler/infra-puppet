#
#   Installs Groovy and make it available in /usr/local/groovy
#

class groovy {
  $version = "2.0.1"
  # http://dist.groovy.codehaus.org/distributions/groovy-binary-2.0.1.zip

  package {
    "unzip" :
      ensure    => installed;
    "openjdk-6-jdk":  # Groovy needs JDK. Any version of JDK would do.
      ensure    => installed;
  }

  exec {
    "install Groovy" :
      unless  => "test -d /usr/local/groovy-${version}",
      command => "wget -O /tmp/groovy.zip http://dist.groovy.codehaus.org/distributions/groovy-binary-${version}.zip && cd /usr/local && unzip /tmp/groovy.zip && ln -snf groovy-${version} groovy";
  }
}
