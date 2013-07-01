class mirrorbrain::tree {
    file {
        # Make sure the directory tree for MirrorBrain to mirror exists
        '/srv' :
            ensure => directory;
        '/srv/releases' :
            ensure => directory;
        '/srv/releases/jenkins' :
            ensure => directory;


        '/srv/releases/jenkins/index.html' :
            ensure  => present,
            source  => 'puppet:///modules/mirrorbrain/index.html',
            require => File['/srv/releases/jenkins'];
        '/srv/releases/populate-fallback.sh':
            ensure  => present,
            mod     => 755,
            source  => 'puppet:///modules/mirrorbrain/populate-fallback.sh';


        '/var/log/apache2' :
            ensure  => directory;
        '/var/log/apache2/mirrors.jenkins-ci.org' :
            ensure  => directory,
            require => File['/var/log/apache2'];
    }
}
