#!/bin/bash

# Installing common dependencies 

apt-get update
apt-get install -y unzip zip dos2unix wget telnet openjdk-8-jdk

echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" > ~/.bash_profile