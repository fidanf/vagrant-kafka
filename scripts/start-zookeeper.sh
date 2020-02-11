#!/bin/bash

echo "==> Starting zookeeper $HOSTNAME"
nohup $KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties 0<&- &> /tmp/zookeeper.log &
sleep 2
