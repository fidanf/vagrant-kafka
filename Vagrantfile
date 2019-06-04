# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  
  config.vm.box = 'rgsystems/xenial64'
  # config.vm.box = 'ubuntu/xenial64'

  # Allow SSH Agent Forward from The Box
  config.ssh.forward_agent = true
  config.ssh.insert_key = false

  vars = {
    'KAFKA_VERSION' => '2.1.1',
    'KAFKA_NAME' => 'kafka_2.11-$KAFKA_VERSION',
    'KAFKA_TARGET' => '/vagrant/tars',
    'KAFKA_SCRIPTS' => '/vagrant/scripts',
    'KAFKA_HOME' => '$HOME/$KAFKA_NAME',
    'ZK_CLUSTER' => 'vkc-zk1:2181,vkc-zk2:2181,vkc-zk3:2181',
    'KAFKA_CLUSTER' => 'vkc-br1:9092,vkc-br2:9092,vkc-br3:9092'
  }

  # escape environment variables to be loaded to /etc/profile.d/
  as_str = vars.map { |k, str| ["export #{k}=#{str.gsub '$', '\$'}"] }.join("\n")

  # provisioning aliases and bash functions
  config.vm.provision "Exporting bash aliases", type: 'shell', run: 'always' do |s|
      s.inline = "awk '{ sub(\"\r$\", \"\"); print }' /vagrant/aliases > /home/vagrant/.bash_aliases"
  end

  # common provisioning for all
  config.vm.provision 'shell', path: 'scripts/common.sh'
  config.vm.provision 'shell', path: 'scripts/hosts-file-setup.sh', env: vars
  config.vm.provision 'shell', inline: "echo \"#{as_str}\" > /etc/profile.d/kafka_vagrant_env.sh", run: 'always'
  config.vm.provision 'shell', path: 'scripts/init.sh', env: vars

  # configure zookeeper cluster
  (1..3).each do |i|
    config.vm.define "zookeeper#{i}" do |s|
      s.vm.hostname = "zookeeper#{i}"
      s.vm.network 'private_network', ip: "10.30.3.#{i + 1}"
      # s.vm.network "private_network", ip: "10.30.3.#{i+1}", netmask: "255.255.255.0", virtualbox__intnet: "my-network", drop_nat_interface_default_route: true
      s.vm.provision 'shell', run: 'always', path: 'scripts/start-zookeeper.sh', args: i.to_s, privileged: false, env: vars
      s.vm.provider 'virtualbox' do |vb|
        #  This setting controls how much cpu time a virtual CPU can use. A value of 50 implies a single virtual CPU can use up to 50% of a single host CPU.
        # vb.customize ['modifyvm', :id, '--cpuexecutioncap', '50']
        vb.customize ['modifyvm', :id, '--cpus', '1']
        vb.customize ['modifyvm', :id, '--memory', '1024']
        vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
        vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
        vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        vb.gui = false
        vb.name = "vkc-zk#{i}"
      end
    end
  end

  # configure brokers
  (1..3).each do |i|
    config.vm.define "broker#{i}" do |s|
      s.vm.hostname = "broker#{i}"
      s.vm.network 'private_network', ip: "10.30.3.#{4 - i}0"
      # s.vm.network "private_network", ip: "10.30.3.#{4-i}0", netmask: "255.255.255.0", virtualbox__intnet: "my-network", drop_nat_interface_default_route: true
      s.vm.provision 'shell', run: 'always', path: 'scripts/start-broker.sh', args: i.to_s, privileged: false, env: vars
      s.vm.provider 'virtualbox' do |vb|
        #  This setting controls how much cpu time a virtual CPU can use. A value of 50 implies a single virtual CPU can use up to 50% of a single host CPU.
        # vb.customize ['modifyvm', :id, '--cpuexecutioncap', '50']
        vb.customize ['modifyvm', :id, '--cpus', '2']
        vb.customize ['modifyvm', :id, '--memory', '2048']
        vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
        vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
        vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        vb.gui = false
        vb.name = "vkc-br#{i}"
      end
    end
  end
end
