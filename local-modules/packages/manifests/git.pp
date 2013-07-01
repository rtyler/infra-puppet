
class packages::git {
    if ($operatingsystem =~ /(RedHat|CentOS)/) {
        package {
            'git' :
                alias  => 'git-core',
                ensure => present;
        }
    }
    else {
        package {
            'git-core' :
                ensure => present;
        }
    }
}
