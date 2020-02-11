#!/bin/bash

echo 'Stopping broker instance...'
$KAFKA_HOME/bin/kafka-server-stop.sh
sleep 2
