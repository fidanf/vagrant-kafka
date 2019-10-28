#!/bin/bash -eux

# create myid file
# see http://zookeeper.apache.org/doc/r3.1.1/zookeeperAdmin.html#sc_zkMulitServerSetup
if [ ! -d $ZK_HOME ]; then
    echo "==> Creating zookeeper data dir..."
    mkdir -p $ZK_HOME
    echo $1 > $ZK_HOME/myid
fi

echo "==> Starting zookeeper..."
nohup $KAFKA_HOME/bin/zookeeper-server-start.sh /vagrant/config/zookeeper.properties 0<&- &> /opt/zookeeper.log &
sleep 2