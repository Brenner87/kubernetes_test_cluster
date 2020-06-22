# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'erb'

#======INPUT_PARAMS========
network = '192.168.47.0/24'
nodes_in_cluster = File.exist?('.node_num') ? File.read('.node_num').to_i : 1
cpu_num = 2
memory = 2048
#==========================

def gen_address(network, num)
  address = network.split('/')[0].split('.')
  address[-1] = (address[-1].to_i + num + 1).to_s
  return address.join('.')
end

def gen_ansible_inventory(cluster)
  puts "Generating ansible inventory\n"
  puts "========================================================="
  template = ERB.new(File.read('hosts.erb'), nil, '<>')
  File.new("ansible/hosts", "w").write(template.result(binding))
  puts template.result(binding)
  puts "========================================================="
end

cluster = (1..nodes_in_cluster).map{
    |n| [n == 1 ? 'kubemaster' : 'kubenode' + (n-1).to_s, gen_address(network, n)] 
}.to_h

if ARGV.include?("up")
  gen_ansible_inventory(cluster)
end

Vagrant.configure("2") do |config|
  config.ssh.username = "vagrant"
  config.ssh.insert_key=false
  config.vm.synced_folder "./", "/vagrant_data"

  cluster.each do |nodename, address|
    config.vm.define nodename do |kubenode|
      kubenode.vm.box = "ubuntu/bionic64"
      kubenode.vm.hostname = nodename
      kubenode.vm.box_url = "ubuntu/bionic64"
      kubenode.vm.network :private_network, ip: address
      kubenode.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", memory]
        v.customize ["modifyvm", :id, "--cpus", cpu_num]
        v.customize ["modifyvm", :id, "--name", nodename]
      end
    end
  end
  config.vm.provision "shell", inline: <<-SHELL 
                                        cat /vagrant_data/ansible/project.key.pub  >> /etc/ssh/authorized_keys
                                        cat /vagrant_data/ansible/project.key.pub  >> /home/vagrant/.ssh/authorized_keys
                                        sed -i -r '/AuthorizedKeysFile/s%^#?\s*(.*)$%\1 /etc/ssh/authorized_keys%' /etc/ssh/sshd_config
  SHELL
end
