#!/bin/bash -ex

if [ -z "$1" ]; then
    echo "Broker id must be supplied!"
    exit 1
fi

if [ ! -d /home/vagrant/kafka-logs ]; then
    mkdir /home/vagrant/kafka-logs
fi

tar -C /home/vagrant/kafka-logs/ -xf $KAFKA_TARGET/kafka-backup.tgz --strip-components=2

# Updating broker id
sed -i "s/broker.id=.*/broker.id=$1/g" /home/vagrant/kafka-logs/meta.properties