#!/bin/bash -eux 

$KAFKA_HOME/bin/kafka-consumer-groups.sh --bootstrap-server $KAFKA_CLUSTER --list