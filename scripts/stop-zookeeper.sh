#!/bin/bash

echo 'stopping zookeeper instance...'
$KAFKA_HOME/bin/zookeeper-server-stop.sh
sleep 2