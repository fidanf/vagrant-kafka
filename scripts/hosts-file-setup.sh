#!/bin/bash

echo "==> Updating hosts file"

echo "
10.30.3.2 zookeeper01
10.30.3.3 zookeeper02
10.30.3.4 zookeeper03

10.30.3.30 broker01
10.30.3.20 broker02
10.30.3.10 broker03
" | tee -a /etc/hosts