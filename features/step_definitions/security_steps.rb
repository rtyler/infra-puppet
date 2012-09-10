Then /^the Nagios server should be whitelisted for denyhosts$/ do
  whitelist_exists = vm.ssh_into('test -f /var/lib/denyhosts/allowed-hosts')
  expect(whitelist_exists).to be(true)

  server_whitelisted = vm.ssh_into('grep "140.211.15.121" /var/lib/denyhosts/allowed-hosts')
  expect(server_whitelisted).to be(true)
end
