#!/bin/bash -ex

if [ -z "$1" ]; then
    echo "Broker id must be supplied!"
    exit 1
fi

if [ ! -d /opt/kafka-logs ]; then
    mkdir /opt/kafka-logs
fi

tar -C /opt/kafka-logs/ -xf $KAFKA_TARGET/kafka-backup.tgz --strip-components=2

# Updating broker id
sed -i "s/broker.id=.*/broker.id=$1/g" /opt/kafka-logs/meta.properties