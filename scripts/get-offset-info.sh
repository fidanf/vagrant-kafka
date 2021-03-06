#!/bin/bash

if [ $# -gt 0 ]; then
    echo "TOPIC NAME | PARTITION ID | LATEST OFFSET"
    $KAFKA_HOME/bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list $KAFKA_CLUSTER --topic $1 --time -1
else
    echo "Usage: "$(basename $0)" <topic_name>"
fi
