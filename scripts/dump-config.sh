#!/bin/bash 

# Prints broker config from the standard server.log file 
# Default file is server.log, which can be overwritten by another server.log.<date> file as a first argument for example

LOG_FILE=${1:-$KAFKA_HOME/logs/server.log}

if [ -f $LOG_FILE ] ; then
  line=$(grep -n 'INFO KafkaConfig values' $LOG_FILE | cut -f1 -d:)
  tail -n +$line $LOG_FILE | head -n 134
else
  echo "$1 does not exists!"
  exit 1;
fi
