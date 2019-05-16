#!/bin/bash

if [ ! -d /tmp/kafka-logs ]; then
    mkdir /tmp/kafka-logs
fi

tar -C /tmp/kafka-logs/ -xf $KAFKA_TARGET/kafka-backup.tgz --strip-components=2