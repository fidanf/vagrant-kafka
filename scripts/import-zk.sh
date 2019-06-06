#!/bin/bash

# create myid file. see http://zookeeper.apache.org/doc/r3.1.1/zookeeperAdmin.html#sc_zkMulitServerSetup
if [ ! -d /tmp/zookeeper ]; then
    echo creating zookeeper data dir...
    mkdir -p /tmp/zookeeper
    echo $1 > /tmp/zookeeper/myid
fi

tar -C /tmp/zookeeper -xzf $KAFKA_TARGET/zookeeper-backup.tar.gz --strip-components=3 version-2

# delete snapshots
# echo 'deleting snapshots'
# ls /tmp/zookeeper/version-2/snapshot.* | xargs rm -f