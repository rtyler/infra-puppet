class ips::repositories {
  # repository definitions
  ips::repository {
    "main":
      name => "",
      port => 8060;
    "stable":
      name => "-stable",
      port => 8061;
    "rc":
      name => "-rc",
      port => 8062;
    "stable-rc":
      name => "-stable-rc",
      port => 8063;
  }
}
