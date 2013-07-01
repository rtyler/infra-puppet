class user-commands {
  group {
    'commands' :
      ensure  => present;
  }

  user {
    'commands' :
      ensure  => present,
      gid     => 'commands',
      groups  => 'infraadmin',
      shell   => '/bin/bash',
      home    => '/home/commands',
      require => [
        Group['commands'],
        Group['infraadmin'],
      ];
  }

  file {
    ['/home/commands','/home/commands/.ssh'] :
      ensure      => directory,
      require     => User['commands'],
      owner       => 'commands',
      group       => 'commands';
    '/home/commands/validate' :
      owner       => 'root',
      group       => 'root',
      mode        => '0755',
      source      => 'puppet:///modules/user-commands/validate';
  }

  file {
    '/home/commands/commands':
      ensure      => directory,
      owner       => 'root',
      group       => 'root',
      mode        => '0755',
      source      => 'puppet:///modules/user-commands/commands',
      recurse     => true,
  }

  ssh_authorized_key {
    'commands' :
      ensure      => present,
      user        => 'commands',
      options     => ['command="/home/commands/validate test@kohsuke.org"'],
      key         => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDN1tfRAjGlqJ6qB9wyfvFtUAbJ8IDW1oBFcky5e43Vg17uSXDcv5DKNDA1sPzs4ZSLEZMCkJtfJ57geRgF8irUZNjUXjZp2TUCt/4TmdDI0HXTv/8PoUa8xGpTl4ZPZDf7srqgFCxWPqwTEJrl0qPkqiDioEMB1kP5oEyl1QBC70h8gK5kdUWIq3d0yEQBkOjl8W5rNphjZdbYvwgzXJ/1RKI/Z1Cc7LpH8UucWdF9L4XRrlIfyCffpfBf6awxA81FOrK6QRdZf5uzBvPVvWUYCRl27kFaj2k3vmavR62hidwodOQ9V1MVM8+1rRk7hPXFYbgCXRepweVhBBGOl/kv',
      type        => 'rsa',
      name        => 'test@kohsuke.org';
  }
}
# vim: shiftwidth=2 expandtab tabstop=2
