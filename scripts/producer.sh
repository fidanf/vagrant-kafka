#!/bin/bash

if [ $# -gt 0 ]; then
    $KAFKA_HOME/bin/kafka-console-producer.sh --topic "$1" --broker-list $KAFKA_CLUSTER
else
    echo "Usage: "$(basename $0)" <topic_name>"
fi
