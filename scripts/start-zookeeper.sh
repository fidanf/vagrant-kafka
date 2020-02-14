#!/bin/bash

echo "==> Starting instance $HOSTNAME"
nohup $KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties 0<&- &> /tmp/zookeeper.log &
sleep 2
