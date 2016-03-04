# -*- mode: ruby -*-
# vi: set ft=ruby :

# require YAML module
require 'yaml'

# load server config from YAML file
CONFIGURATION_YAML = YAML.load_file('config.yaml')
$puppet_lib_install_script = <<EOF
   mkdir -p /etc/puppet/modules;
   if [ ! -d /etc/puppet/modules/stdlib ]; then
      puppet module install puppetlabs/stdlib
   fi
   if [ ! -d /etc/puppet/modules/java ]; then
      puppet module install 7terminals-java
   fi
EOF

Vagrant.configure(2) do |config|

	CONFIGURATION_YAML["servers"].each do |server|
		if (defined?(server['enabled']) && server['enabled'] != false)
      puts "Provisioning VirtualBox with hostname: ", server['hostname']
			config.vm.define server["hostname"] do |server_config|
				server_config.vm.box = server["box"]
				server_config.vm.host_name = server["hostname"]
				server_config.vm.network :private_network, ip: server["ip"]
        server_config.vm.synced_folder(CONFIGURATION_YAML["puppet"]["puppet_home"] + "/hieradata", "/puppet/hieradata")
				memory = server["ram"] ? server["ram"] : 256;

				server_config.vm.provider :virtualbox do |vb|
					vb.name = server["hostname"]
					vb.check_guest_additions = false
					vb.functional_vboxsf = false
					vb.gui = false
					vb.customize ["modifyvm", :id, "--groups", "/WSO2-Puppet-Dev"]
					vb.customize ["modifyvm", :id, "--memory", server["ram"]]
					vb.customize ["modifyvm", :id, "--cpus", server["cpu"]]
				end

				server_config.vm.provision :shell do |shell|
					shell.inline = $puppet_lib_install_script
				end

				server_config.vm.provision :puppet do |puppet|
          puppet.manifest_file = 'site.pp'
					puppet.manifests_path = CONFIGURATION_YAML["puppet"]["puppet_home"] + "/manifests"
					puppet.module_path = CONFIGURATION_YAML["puppet"]["puppet_home"] + "/modules"
					puppet.hiera_config_path = CONFIGURATION_YAML["puppet"]["puppet_home"] + "/hiera.yaml"
					puppet.working_directory = "/puppet"

					# custom facts provided to Puppet
					puppet.facter = server["facters"]
				end
			end
		end
	end
end
