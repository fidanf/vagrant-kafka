#!/bin/bash -eux

FILENAME="kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"

url=$(curl --stderr /dev/null "https://www.apache.org/dyn/closer.cgi?path=/kafka/${KAFKA_VERSION}/${FILENAME}&as_json=1" | jq -r '"\(.preferred)\(.path_info)"')

# Test to see if the suggested mirror has this version, currently pre 2.1.1 versions
# do not appear to be actively mirrored. This may also be useful if closer.cgi is down.
if [[ ! $(curl -s -f -I "${url}") ]]; then
    echo "Mirror does not have desired version, downloading direct from Apache"
    url="https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/${FILENAME}"
fi

echo "Downloading Kafka from $url"
wget -q "${url}" -O "/tmp/${FILENAME}"

echo "==> Extracting files"
mkdir -p $KAFKA_HOME
tar -C $KAFKA_HOME -zvxf "/tmp/${FILENAME}" --strip-components=1 && echo "==> Done."

# refresh permissions
chown vagrant:vagrant -R $KAFKA_HOME

# chmod scripts
chmod u+x /vagrant/scripts/*.sh
