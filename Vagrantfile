# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  

  config.vm.box = 'rgsystems/bionic64'

  # Allow SSH Agent Forward from The Box
  config.ssh.forward_agent = true
  config.ssh.insert_key = false

  vars = {
    'KAFKA_VERSION' => '0.10.0.1',
    'KAFKA_NAME' => 'kafka_2.11-$KAFKA_VERSION',
    'KAFKA_TARGET' => '/vagrant/tars',
    'KAFKA_SCRIPTS' => '/vagrant/scripts',
    'KAFKA_HOME' => '/opt/$KAFKA_NAME',
    'ZK_CLUSTER' => 'zookeeper01:2181,zookeeper02:2181,zookeeper03:2181',
    'KAFKA_CLUSTER' => 'broker01:9092,broker02:9092,broker03:9092'
  }

  # escape environment variables to be loaded to /etc/profile.d/
  as_str = vars.map { |k, str| ["export #{k}=#{str.gsub '$', '\$'}"] }.join("\n")

  # assigning archives to variables
  confDir = File.expand_path(File.dirname(__FILE__))
  zookeeper_archive = confDir + '/tars/zookeeper-backup.tar.gz'
  kafka_archive = confDir + '/tars/kafka-backup.tar.gz'

  # provisioning aliases and bash functions
  config.vm.provision "Exporting bash aliases", type: 'shell', run: 'always' do |s|
    s.inline = "awk '{ sub(\"\r$\", \"\"); print }' /vagrant/aliases > /home/vagrant/.bash_aliases"
  end

  # common provisioning for all
  config.vm.provision 'shell', path: 'scripts/common.sh'
  config.vm.provision 'shell', path: 'scripts/hosts-file-setup.sh', env: vars
  config.vm.provision 'shell', inline: "echo \"#{as_str}\" > /etc/profile.d/kafka_vagrant_env.sh", run: 'always'
  config.vm.provision 'shell', path: 'scripts/init.sh', env: vars

  # make vagrant scripts globally available
  config.vm.provision "Creating script symlinks", type: 'shell', run: 'once' do |s|
    s.inline = "find $KAFKA_SCRIPTS/ -name \"*.sh\" -exec ln -s {} /usr/local/bin/ \\;"
  end

  # configure zookeeper cluster
  (1..3).each do |i|
    config.vm.define "zookeeper0#{i}" do |s|
      s.vm.hostname = "zookeeper0#{i}"
      s.vm.network 'private_network', ip: "10.30.3.#{i + 1}"
      # s.vm.network "private_network", ip: "10.30.3.#{i+1}", netmask: "255.255.255.0", virtualbox__intnet: "my-network", drop_nat_interface_default_route: true
      
      if File.exist? zookeeper_archive then
        s.vm.provision "Importing zookeeper's data", type: 'shell', run: 'once' do |s| 
          s.path = 'scripts/import-zk.sh'
          s.privileged = false
          s.env = vars
          s.args = i.to_s
        end
      end

      s.vm.provision 'shell', run: 'always', path: 'scripts/start-zookeeper.sh', privileged: false, env: vars, args: i.to_s

      s.vm.provider 'virtualbox' do |vb|
        #  This setting controls how much cpu time a virtual CPU can use. A value of 50 implies a single virtual CPU can use up to 50% of a single host CPU.
        # vb.customize ['modifyvm', :id, '--cpuexecutioncap', '50']
        vb.customize ['modifyvm', :id, '--cpus', '1']
        vb.customize ['modifyvm', :id, '--memory', '1024']
        vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
        vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
        vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        vb.gui = false
        vb.name = "zookeeper0#{i}"
      end
    end
  end

  # configure brokers
  (1..3).each do |i|
    config.vm.define "broker0#{i}" do |s|
      s.vm.hostname = "broker0#{i}"
      s.vm.network 'private_network', ip: "10.30.3.#{4 - i}0"
      # s.vm.network "private_network", ip: "10.30.3.#{4-i}0", netmask: "255.255.255.0", virtualbox__intnet: "my-network", drop_nat_interface_default_route: true
      
      if File.exist? kafka_archive then
        s.vm.provision "Importing kafka's topics", type: 'shell', run: 'once' do |s| 
          s.path = 'scripts/import-kafka.sh'
          s.privileged = false
          s.env = vars
          s.args = i.to_s
        end
      end

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
        vb.name = "broker0#{i}"
      end
    end
  end
end
