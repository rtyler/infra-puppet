class nagios::server {
  include apache2
  include nagios::client
  $nagios_dir = '/etc/nagios3'
  $nagios_cfg_dir = "${nagios_dir}/conf.d"
  $jenkins_cfg_dir = "${nagios_cfg_dir}/jenkinsci"

  class {
    "nagios::server::packages"  : ;
    "nagios::server::service"   : ;
    "nagios::server::commands"  : ;
    "nagios::server::hosts"     : ;
    "nagios::server::checks"    : ;
    "nagios::server::permissions": ;
    "nagios::server::contacts"  : ;
  }

  ## nagios-client should always get run first since it will create the nagios
  ## user and set up some basic permissions
  Class['nagios::client'] ->
    Class['nagios::server::packages'] ->
      Class['nagios::server'] ->
        Class['nagios::server::hosts'] ->
          Class['nagios::server::checks'] ->
            Class['nagios::server::contacts'] ->
              Class['nagios::server::permissions']

  # Nuke any "old" jenkins nagios configuration files, basically these
  # configuration files were created in a non-file-per-service manner which
  # makes ensure => absent possible
  exec {
    'nuke-old-nagios-configs' : 
      path    => ['/bin', '/usr/bin'],
      command => "rm -rf ${nagios_cfg_dir}/jenkins",
      onlyif  => "test -d ${nagios_cfg_dir}/jenkins";
  }



  file {
    $jenkins_cfg_dir :
      ensure  => directory,
      mode  => 755,
      require => [
            Group["nagios"],
            Class["nagios::server::packages"],
      ];

    "${nagios_dir}/htpasswd.users" :
      ensure => present,
      require => [
            Class["nagios::server::packages"],
      ],
      source => "puppet:///modules/nagios/nagios.htpasswd";

    "${nagios_dir}/cgi.cfg" :
      ensure => present,
      require => [
            Class["nagios::server::packages"],
      ],
      source => "puppet:///modules/nagios/nagios.cgi.cfg";

    "${nagios_dir}/nagios.cfg" :
      ensure => present,
      require => [
            Class["nagios::server::packages"],
      ],
      source => "puppet:///modules/nagios/nagios.cfg";

    "/var/lib/nagios3" :
      ensure => directory,
      mode   => 751,
      require => [
            Class["nagios::server::packages"],
      ];

    "/var/lib/nagios3/rw" :
      ensure  => directory,
      group   => "www-data",
      mode  => 2710,
      require => [
            Class["nagios::server::packages"],
      ];

    "/etc/apache2/sites-enabled/nagios.jenkins-ci.org" :
      ensure  => present,
      require => [
            Class["apache2"],
            Class["nagios::server::packages"],
      ],
      source => "puppet:///modules/nagios/apache2.conf";


    # Nagios Pager Duty integration
    # Thanks pagerduty.com for the gratis account!
    "/usr/local/bin/pagerduty_nagios.pl" :
      ensure => present,
      mode   => 755,
      source => "puppet:///modules/nagios/pagerduty_nagios.pl";

    # This file is dropped onto the host directly as it
    # contains the API key
    "${nagios_cfg_dir}/pagerduty_nagios.cfg" :
      ensure => present,
      require => [
            Class["nagios::server::packages"],
      ],
      notify => Service["nagios"],
      source => [
            "puppet:///modules/nagios/pagerduty_nagios.cfg",
            "puppet:///modules/nagios/pagerduty_nagios.cfg.dummy",
          ];
  }

  cron {
    "pagerduty_flush" :
      command => "/usr/local/bin/pagerduty_nagios.pl",
      require => File["/usr/local/bin/pagerduty_nagios.pl"],
      user  => nagios;
  }


  define basic-host($full_name, $os = 'ubuntu', $ensure ='present') {
    if ($os == 'ubuntu') {
      $disk_status = $ensure
    }
    else {
      $disk_status = 'absent'
    }

    nagios::server::check-disk {
      $name :
        ensure => $disk_status;
    }

    nagios_host {
      $full_name :
        ensure     => $ensure,
        alias      => $name,
        contact_groups => "core-admins",
        check_command  => "check_ssh_4",
        target     => "${nagios::server::jenkins_cfg_dir}/${name}_host.cfg",
        notify     => [
                  Service["nagios"],
                  Class['nagios::server::permissions']
        ],
        use      => "generic-host";
    }

    nagios_hostextinfo {
      $full_name:
        ensure => $ensure,
        notify     => [
                  Service["nagios"],
                  Class['nagios::server::permissions']
        ],
        icon_image_alt => $os,
        icon_image => "base/${os}.png",
        statusmap_image => "base/${os}.gd2",
        target => "${nagios::server::jenkins_cfg_dir}/${name}_hostextinfo.cfg",
    }

    # Disable ping checks for kale. It has unmanaged iptable rules that
    # drop all inbound ICMP traffic. I'd rather fix those iptable rules once
    # kale is more properly managed by puppet
    if ($name == 'kale') {
      $ping_status = 'absent'
    }
    else {
      $ping_status = $ensure
    }

    nagios_service {
      "check_ping_${name}":
        target        => "${nagios::server::jenkins_cfg_dir}/${name}_check_ping_service.cfg",
        notify     => [
                  Service["nagios"],
                  Class['nagios::server::permissions']
        ],
        ensure        => $ping_status,
        contact_groups    => "core-admins",
        service_description   => "Ping",
        check_command     => "check-host-alive",
        host_name       => "$full_name",
        notification_interval => 5,
        use           => "generic-service";


      "check_ssh_${name}":
        target        => "${nagios::server::jenkins_cfg_dir}/${name}_check_ssh_service.cfg",
        notify     => [
                  Service["nagios"],
                  Class['nagios::server::permissions']
        ],
        ensure        => $ensure,
        contact_groups    => "core-admins",
        service_description   => "SSH",
        check_command     => "check_ssh_4",
        host_name       => "$full_name",
        notification_interval => 5,
        use           => "generic-service";
    }

    if ($os == 'ubuntu') {
      $puppet_ensure = $ensure
    }
    else {
      $puppet_ensure = 'absent'
    }
    nagios_service {
      "check_puppet_run_${name}" :
        target        => "${nagios::server::jenkins_cfg_dir}/${name}_check_puppet_run_service.cfg",
        notify     => [
                  Service["nagios"],
                  Class['nagios::server::permissions']
        ],
        ensure        => $puppet_ensure,
        contact_groups    => "core-admins",
        service_description   => "Puppet",
        check_command     => "check_puppet_run_by_ssh",
        host_name       => "$full_name",
        notification_interval => 5,
        use           => "generic-service";
    }
  }

  define check-http($ensure = present) {
    nagios_service {
      "http check $name" :
        target        => "${nagios::server::jenkins_cfg_dir}/http_${name}_service.cfg",
        notify     => [
                  Service["nagios"],
                  Class['nagios::server::permissions']
        ],
        ensure        => $ensure,
        contact_groups    => "core-admins",
        service_description => "HTTP",
        check_command     => "check_http_4",
        host_name       => "${name}.jenkins-ci.org",
        use         => "generic-service",
    }
  }

  define check-https($ensure = present) {
    nagios_service {
      "https check ${name}" :
        target        => "${nagios::server::jenkins_cfg_dir}/http_${name}_service.cfg",
        notify     => [
                  Service["nagios"],
                  Class['nagios::server::permissions']
        ],
        ensure        => $ensure,
        contact_groups    => "core-admins",
        service_description => "HTTPs",
        check_command     => "check_https_4",
        host_name       => "${name}.jenkins-ci.org",
        use         => "generic-service",
    }
  }

  define check-disk($ensure = present) {
    nagios_service {
      "disk check $name" :
        target        => "${nagios::server::jenkins_cfg_dir}/${name}_disk.cfg",
        notify     => [
                  Service["nagios"],
                  Class['nagios::server::permissions']
        ],
        ensure        => $ensure,
        contact_groups    => "core-admins",
        service_description => "Disk availability",
        check_command     => "check_disk_by_ssh!1500!750",  # Unit is MB (otherwise use 10%, etc)
        host_name       => "${name}.jenkins-ci.org",
        use         => "generic-service",
    }
  }
}

# vim: shiftwidth=2 expandtab tabstop=2
