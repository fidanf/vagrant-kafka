Vagrant - Kafka
=============

Vagrant configuration to setup a partitioned Apache Kafka installation with clustered Apache Zookeeper.

This configuration will start and provision six Ubuntu16 VMs:

* Three hosts forming a three node Apache Zookeeper Quorum (Replicated ZooKeeper)
* Three Apache Kafka nodes with one broker each

Each host is a Ubuntu 18.04 64-bit VM provisioned with JDK 8 and Kafka version (`0.10.0.1` by default), which can be modified in the Vagrantfile to suit your needs. 

Here we will be using the verion of Zookeeper that comes pre-packaged with Kafka. This will be Zookeeper version `3.4.10` by default. 

Prerequisites
-------------------------

* Vagrant (tested with 2.2.7) **[make sure you are on 2.x.x version of Vagrant]**
* VirtualBox (tested with 6.1.2)

Setup
-------------------------

To start it up, just git clone this repo and execute ```vagrant up```. This will take a while the first time as it downloads all required dependencies for you.

Kafka is installed on all hosts and can be easily accessed through the environment variable ```$KAFKA_HOME```
Handy custom bash scripts warping the most common shell commands are available from either ```/vagrant/scripts``` or the environment variable ```$KAFKA_SCRIPTS```

Here is the mapping of VMs to their private IPs:

| VM Name    | Host Name     | IP Address |
| ---------- | ------------- | ---------- |
| zookeeper01 | zookeeper01   | 10.30.3.2  |
| zookeeper02 | zookeeper02   | 10.30.3.3  |
| zookeeper03 | zookeeper03   | 10.30.3.4  |
| broker01    | broker01      | 10.30.3.30 |
| broker02    | broker02      | 10.30.3.20 |
| broker03    | broker03      | 10.30.3.10 |

Hosts file entries:

```
10.30.3.2	zookeeper01
10.30.3.3 	zookeeper02
10.30.3.4 	zookeeper03
10.30.3.30 	broker01
10.30.3.20 	broker02
10.30.3.10 	broker03
```

Zookeeper servers bind to port 2181. Kafka brokers bind to port 9092. 

Let's test it!
-------------------------

First test that all nodes are up ```vagrant status```. The result should be similar to this:

```
Current machine states:

zookeeper01                running (virtualbox)
zookeeper02                running (virtualbox)
zookeeper03                running (virtualbox)
broker01                   running (virtualbox)
broker02                   running (virtualbox)
broker03                   running (virtualbox)


This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run 'vagrant status NAME''.
```

Login to any host with e.g., ```vagrant ssh broker1```. Some scripts have been included for convenience:

* Create a new topic ```/vagrant/scripts/create-topic.sh <topic name>``` (create as many as you see fit)

  **Note:** If this step fails, exit the VM and run ```vagrant up --provision``` (if error persists, please file an issue) 

* Topics can be listed with ```/vagrant/scripts/list-topics.sh```

* Start a console producer ```/vagrant/scripts/producer.sh <topic name>```. Type few messages and seperate them with new lines (`ctrl+c` to exit). 

* ```/vagrant/scripts/consumer.sh <topic name>```: this will create a console consumer, getting messages from the topic created before. It will read all the messages each time starting from the beginning.

Now anything you type in producer, it will show on the consumer. 


#### Teardown


To destroy all the VMs

```bash
vagrant destroy -f
```


## Insights

### Zookeeper (ZK)

Kafka is using ZK for its coordination, bookkeeping, and configuration. 
Here are some commands you can run on any of the nodes to see some of the internal ZK structures created by Kafka. 

#### Open a ZK shell

```$KAFKA_HOME/bin/zookeeper-shell.sh 10.30.3.2:2181``` 

Using custom script (uses all 3 IPs)

```~/zookeeper-shell.sh``` 

(you can use the IP of any of the ZK servers)


Inside the shell we can browse the zNodes similar to a Linux filesystem: 

```bash
ls /
[cluster, controller, controller_epoch, brokers, zookeeper, admin, isr_change_notification, consumers, log_dir_event_notification, latest_producer_id_block, config]

ls /brokers/topics
[t1, t2, __consumer_offsets]

ls /brokers/ids
[1, 2, 3]
```

We can see that there are two topics created (t1, t2) and we already know that we have three brokers with ids 1,2,3. 

After you have enough fun browsing ZK, type `ctrl+c` to exit the shell.

#### Get ZK version

To get the version of ZK type:

```bash
echo status | nc zookeeper0<ID> 2181
```

You can replace <ID> with any ZK id (1, 2 or 3) and execute the above command from any node within the cluster. 

*Q: Which Zookeeper server is the leader?*

Here is a simple script that asks each server for its mode:

```bash
for i in 1 2 3 ; do
   echo "zookeeper0$i is a "$(echo status | nc zookeeper0$i 2181 | grep ^Mode | awk '{print $2}')
done
```

### Kafka

Let's explore other ways to ingest data to Kafa from the command line. 

Login to any of the 6 nodes

```bash
vagrant ssh zookeeper1
```

Create a topic 

```bash
$KAFKA_SCRIPTS/create-topic.sh test-one
# using symlink from the home directory
~/create-topic.sh test-one
```

Send data to the Kafka topic

```bash
echo "Yet another line from stdin" | $KAFKA_HOME/bin/kafka-console-producer.sh \
   --topic test-one --broker-list broker01:9092,broker02:9092,broker03:9092
# using shorthand script :
echo "One more line from stdin" | ~/producer.sh test-one 
```

You can then test that the line was added by running the consumer

```bash
$KAFKA_SCRIPTS/consumer-new.sh test-one
# legacy versions:
$KAFKA_SCRIPTS/consumer-old.sh test-one
```

Set custom log retention for a given topic

```bash
$KAFKA_HOME/bin/kafka-configs.sh --zookeeper $ZK_CLUSTER --entity-type topics --entity-name my-topic \
   --alter --add-config segment.bytes=12288
```

Dump broker configuration after start

```bash
$KAFKA_SCRIPTS/dump-config.sh
# look for an older server.log file
$KAFKA_SCRIPTS/dump-config.sh server.log.2019-06-20-11
```

Describe single / every topics
```bash
~/describe-topics
~/describe-topics <topic_name>
```


##### Add a continued stream of data

Running `vmstat` will periodically export stats about the VM you are attached to. 

```bash
>vmstat -a 1 -n 100

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
 r  b   swpd   free  inact active   si   so    bi    bo   in   cs us sy id wa st
 0  0    960 113312 207368 130500    0    0    82   197  130  176  0  1 99  0  0
 0  0    960 113312 207368 130500    0    0     0     0   60   76  0  0 100  0  0
 0  0    960 113304 207368 130540    0    0     0     0   58   81  0  0 100  0  0
 0  0    960 113304 207368 130540    0    0     0     0   53   76  0  1 99  0  0
 0  0    960 113304 207368 130540    0    0     0     0   53   78  0  0 100  0  0
 0  0    960 113304 207368 130540    0    0     0    16   64   90  0  0 100  0  0
```

Redirecing this output to Kafka creates a basic form of a streaming producer.

```bash
vmstat -a 1 -n 100 | $KAFKA_HOME/bin/kafka-console-producer.sh \
   --topic test-one --broker-list broker01:9092,broker02:9092,broker03:9092 &
```

Using producer.sh script 

```bash
vmstat -a 1 -n | ~/producer.sh topicTest &
```

While the producer runs in the background you can start the consumer to see what happens

```bash
~/consumer.sh test-one
```

You should be seeing the output of `vmstat` in the consumer console. 

When you are all done, kill the consumer by `ctrl+c`. The producer will terminate by itself after 100 seconds.


#### Offsets

The `create-topic.sh` script creates a topic with replication factor 3 and 1 number of partitions. 

Assuming you have completed the `vmstat` example above using topic `test-one`:

```bash
$KAFKA_SCRIPTS/get-offset-info.sh test-one
test-one:0:102
```

There is one partition (id 0) and the last offset was 102 (from `vmstat`: 100 lines of reports + 2 header lines)
We asked Kafka for the last offset written so far using `--time -1` (as seen in [get-offset-info.sh](scripts/get-offset-info.sh)). You can change the time to `-2` to get the first offset. 
