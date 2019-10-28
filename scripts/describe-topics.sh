#!/bin/bash

# Describe single topic if topic name arg is provided
if [ $# -gt 0 ]; then
   $KAFKA_HOME/bin/kafka-topics.sh --describe --topic $1 --zookeeper $ZK_CLUSTER
# Else describe all topics
else 
   $KAFKA_HOME/bin/kafka-topics.sh --describe --zookeeper $ZK_CLUSTER
fi