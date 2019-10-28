#!/bin/bash -eux

echo "==> Downloading kafka...$KAFKA_VERSION"

# download kafka binaries if not present
if [ ! -f  $KAFKA_TARGET/$KAFKA_NAME.tgz ] ; then

    mkdir -p $KAFKA_TARGET
    # v2.1.1, 2.2.0, 2.2.1, 2.3.0, 2.3.1
    # wget -O "$KAFKA_TARGET/$KAFKA_NAME.tgz" hhttps://www-eu.apache.org/dist/kafka/"$KAFKA_VERSION/$KAFKA_NAME.tgz"
    # 2.1.0 or lower
    wget -O "/$KAFKA_TARGET/$KAFKA_NAME.tgz" https://archive.apache.org/dist/kafka/"$KAFKA_VERSION/$KAFKA_NAME.tgz"
fi

echo "==> Installing JDK and Kafka..."

if [ ! -d $KAFKA_HOME ] ; then 
   tar -xzf "/$KAFKA_TARGET/$KAFKA_NAME.tgz" -C /opt --strip-components=1
fi

chown vagrant:vagrant -R $KAFKA_NAME

echo "==> Done installing JDK and Kafka..."

# chmod scripts
chmod u+x /vagrant/scripts/*.sh
