
class pkg-apache2 {
    if $operatingsystem == "CentOS" {
        #yumrepo {
        #    # We need at least Apache 2.2.6 for MirrorBrain
        #    "Apache" :
        #        baseurl => "http://download.opensuse.org/repositories/Apache/CentOS_5/",
        #        descr => "Apache OBS repo",
        #        enabled => 1,
        #        gpgcheck => 0;
        #}

        package {
            "httpd" :
                alias => "apache2",
                ensure => installed;

            "httpd-devel" :
                ensure => installed;
        }
    }
    else {
        package {
            "apache2" :
                alias => "apache2",
                ensure  => installed;
        }
    }
}
