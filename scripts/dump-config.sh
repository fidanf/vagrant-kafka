#!/bin/bash 

# Look for latest server.log
LOG_FILE=$KAFKA_HOME/logs/server.log

if [ -f $LOG_FILE ] ; then
  grep -q 'INFO KafkaConfig values' $LOG_FILE && head --lines=134 $LOG_FILE
fi
