# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'rgsystems/bionic64'

  # Allow SSH Agent Forward from The Box
  config.ssh.forward_agent = true
  config.ssh.insert_key = false

  vars = {
    'KAFKA_VERSION' => '0.10.0.1',
    'SCALA_VERSION' => '2.11',
    'KAFKA_NAME' => 'kafka_$SCALA_VERSION-$KAFKA_VERSION',
    'KAFKA_HOME' => '$HOME/$KAFKA_NAME',
    'ZK_CLUSTER' => 'zookeeper01:2181,zookeeper02:2181,zookeeper03:2181',
    'KAFKA_CLUSTER' => 'broker01:9092,broker02:9092,broker03:9092',
    'KAFKA_SCRIPTS' => '/vagrant/scripts'
  }

  # provisioning aliases and bash functions
  config.vm.provision "Exporting bash aliases", type: 'shell', run: 'always' do |s|
    s.inline = "awk '{ sub(\"\r$\", \"\"); print }' /vagrant/aliases > /home/vagrant/.bash_aliases"
  end

  # escape environment variables to be loaded to /etc/profile.d/
  as_str = vars.map { |k, str| ["export #{k}=#{str.gsub '$', '\$'}"] }.join("\n")
  config.vm.provision 'shell', inline: "echo \"#{as_str}\" > /etc/profile.d/kafka_vagrant_env.sh", run: 'always'
  config.vm.provision 'shell', path: 'scripts/hosts-file-setup.sh', env: vars

  # install kafka and dependencies
  config.vm.provision 'shell', path: 'scripts/common.sh'
  config.vm.provision 'shell', path: 'scripts/download-kafka.sh', privileged: false, env: vars

  # make vagrant scripts globally available
  config.vm.provision "Creating script symlinks", type: 'shell', run: 'once' do |s|
    s.inline = "find $KAFKA_SCRIPTS/ -name \"*.sh\" -exec ln -s {} /usr/local/bin/ \\;"
  end

  # configure zookeeper cluster
  (1..3).each do |i|
    config.vm.define "zookeeper0#{i}" do |s|
      s.vm.hostname = "zookeeper0#{i}"
      s.vm.network 'private_network', ip: "10.30.3.#{i + 1}"
      s.vm.provider 'virtualbox' do |vb|
        vb.gui = false
        vb.name = "zookeeper0#{i}"
        vb.customize ['modifyvm', :id, '--cpus', '1']
        vb.customize ['modifyvm', :id, '--memory', '1024']
        vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
        vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
        vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      end

      s.vm.provision 'shell', run: 'always', path: 'scripts/configure-zookeeper.sh', privileged: false, env: vars, args: i.to_s
      s.vm.provision 'shell', run: 'always', path: 'scripts/start-zookeeper.sh', privileged: false, env: vars, args: i.to_s

    end
  end

  # configure brokers
  (1..3).each do |i|
    config.vm.define "broker0#{i}" do |s|
      s.vm.hostname = "broker0#{i}"
      s.vm.network 'private_network', ip: "10.30.3.#{4 - i}0"
      s.vm.provider 'virtualbox' do |vb|
        vb.gui = false
        vb.name = "broker0#{i}"
        vb.customize ['modifyvm', :id, '--cpus', '2']
        vb.customize ['modifyvm', :id, '--memory', '2048']
        vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
        vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
        vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      end

      s.vm.provision 'shell', run: 'always', path: 'scripts/configure-broker.sh', privileged: false, env: vars, args: i.to_s
      s.vm.provision 'shell', run: 'always', path: 'scripts/start-broker.sh', args: i.to_s, privileged: false, env: vars

    end
  end
end
