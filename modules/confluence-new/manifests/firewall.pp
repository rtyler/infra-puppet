class confluence::firewall {
  firewall {
  '100 accept inbound HTTP requests' :
    proto  => 'tcp',
    port   => 80,
    action => 'accept';

  '101 accept inbound HTTPs requests' :
    proto  => 'tcp',
    port   => 443,
    action => 'accept';
  }
}
