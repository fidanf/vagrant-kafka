#!/bin/bash

tar -C /tmp/zookeeper -xzf $KAFKA_TARGET/zookeeper-backup.tar.gz --strip-components=2
pushd /tmp/zookeeper/
mv zookeeper/version-2/* version-2/
rm -rf zookeeper/
popd