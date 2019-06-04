#!/bin/bash

if [ -z "$1" ]; then
    echo "Broker id must be supplied!"
    exit 1
fi

if [ ! -d /tmp/kafka-logs ]; then
    mkdir /tmp/kafka-logs
fi

tar -C /tmp/kafka-logs/ -xf $KAFKA_TARGET/kafka-backup.tgz --strip-components=2

# Updating broker id
sed -i "s/broker.id=.*/broker.id=$1/g" /tmp/kafka-logs/meta.properties