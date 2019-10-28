#!/bin/bash -ex

# create myid file. see http://zookeeper.apache.org/doc/r3.1.1/zookeeperAdmin.html#sc_zkMulitServerSetup
if [ ! -d /home/vagrant/zookeeper ]; then
    echo creating zookeeper data dir...
    mkdir -p /home/vagrant/zookeeper
    echo $1 > /home/vagrant/zookeeper/myid
fi

tar -xzf $KAFKA_TARGET/zookeeper-backup.tar.gz -C /home/vagrant/zookeeper --strip-components=3 var/lib/zookeeper/version-2

# delete snapshots
# echo 'deleting snapshots'
# ls /tmp/zookeeper/version-2/snapshot.* | xargs rm -f