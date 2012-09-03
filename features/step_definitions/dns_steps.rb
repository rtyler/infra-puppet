Given /^I have included the Jenkins DNS module$/ do
  resources << 'include jenkins-dns'
end

Then /^the Jenkins DNS server should be in the resolv\.conf$/ do
  found = vm.ssh_into('grep "140.211.15.121" /etc/resolv.conf')
  expect(found).to be(true)
end

