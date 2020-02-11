#!/bin/bash

echo "==> Starting broker $HOSTNAME"
$KAFKA_HOME/bin/kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties
