#!/bin/bash -eux

cp /vagrant/config/server.properties $KAFKA_HOME/config/server.properties && dos2unix $KAFKA_HOME/config/server.properties

echo "==> Set broker.id"
sed -i "s/broker.id=.*/broker.id=$1/g" $KAFKA_HOME/config/server.properties
echo "==> Set host.name"
sed -i "s/host.name=.*/host.name=$HOSTNAME/g" $KAFKA_HOME/config/server.properties
echo "==> Set zookeeper.connect"
sed -i "s/zookeeper.connect=.*/zookeeper.connect=$ZK_CLUSTER/g" $KAFKA_HOME/config/server.properties
