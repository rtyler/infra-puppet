
class pkg-apache2 {
    if $operatingsystem == "CentOS" {
        package {
            "httpd" :
                alias   => apache2,
                ensure  => installed;
        }
    }
    else {
        package {
            "apache2" :
                alias   => apache2,
                ensure  => installed;
        }
    }
}
