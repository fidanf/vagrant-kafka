#!/bin/bash

echo '==> Stopping zookeeper instance'
$KAFKA_HOME/bin/zookeeper-server-stop.sh
sleep 2