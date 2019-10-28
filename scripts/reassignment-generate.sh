#!/bin/bash

echo '{"topics": [' > topics-to-move.json
$KAFKA_HOME/bin/kafka-topics.sh --zookeeper $ZK_CLUSTER --list | perl -ne 'chomp;print "{\"topic\": \"$_\"},\n"' >> topics-to-move.json
truncate --size=-2 topics-to-move.json
echo -e '],\n"version":1}' >> topics-to-move.json