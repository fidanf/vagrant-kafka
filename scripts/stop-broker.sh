#!/bin/bash

echo 'stopping kafka broker...'
$KAFKA_HOME/bin/kafka-server-stop.sh
sleep 2
