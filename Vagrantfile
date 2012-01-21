Vagrant::Config.run do |config|
  if ENV['REDHAT'] == '1'
    config.vm.box     = 'centos-6-x86_64'
    config.vm.box_url = 'http://dl.dropbox.com/u/1627760/centos-6.0-x86_64.box'
  else
    config.vm.box     = "lucid32"
    config.vm.box_url = "http://files.vagrantup.com/lucid32.box"
  end

  config.vm.customize ["modifyvm", :id, "--memory", "768"]

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  config.vm.forward_port 80, 18080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path    = "modules"
    puppet.manifest_file  = "vagrant.pp"
  end
end
