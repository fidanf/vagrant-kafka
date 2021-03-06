#!/bin/bash

# broker api >= 0.11.0.x
if [ $# -gt 0 ]; then
    $KAFKA_HOME/bin/kafka-console-consumer.sh --from-beginning --topic $1 --bootstrap-server $KAFKA_CLUSTER
else
    echo "Usage: "$(basename $0)" <topic_name>"
fi
