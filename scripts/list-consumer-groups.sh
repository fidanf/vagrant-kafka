#!/bin/bash

if [ $KAFKA_VERSION == '0.10.0.1' ] ; then 
    $KAFKA_HOME/bin/kafka-consumer-groups.sh --zookeeper $ZK_CLUSTER --list
    exit 0
fi

$KAFKA_HOME/bin/kafka-consumer-groups.sh --bootstrap-server $KAFKA_CLUSTER --list