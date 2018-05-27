#!/bin/bash

# start node1
sudo docker rm -f node1 &> /dev/null
echo "start node1 container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                --name node1 \
                --hostname node1 \
                wangsongbai/hadoop:2.0 &> /dev/null

# start node2
sudo docker rm -f node2 &> /dev/null
echo "start node2 container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50072:50072 \
                --name node2 \
                --hostname node2 \
                wangsongbai/hadoop:2.0 &> /dev/null

# start node3
sudo docker rm -f node3 &> /dev/null
echo "start node3 container..."
sudo docker run -itd \
                --net=hadoop \
                -p 38088:8088 \
                -p 10020:10020 \
                -p 19888:19888 \
                --name node3 \
                --hostname node3 \
                wangsongbai/hadoop:2.0 &> /dev/null

# start node4
sudo docker rm -f node4 &> /dev/null
echo "start node4 container..."
sudo docker run -itd \
                --net=hadoop \
                -p 48088:8088 \
                --name node4 \
                --hostname node4 \
                wangsongbai/hadoop:2.0 &> /dev/null

# start node5
sudo docker rm -f node5 &> /dev/null
echo "start node5 container..."
sudo docker run -itd \
                --net=hadoop \
                -p 60010:60010 \
                -p 60030:60030 \
                --name node5 \
                --hostname node5 \
                wangsongbai/hadoop:2.0 &> /dev/null

#zookeeper配置
sudo docker exec node2 cp /tmp/myid2 /opt/zookeeper/myid
#zookeeper配置
sudo docker exec node1 cp /tmp/myid1 /opt/zookeeper/myid
#zookeeper配置
sudo docker exec node3 cp /tmp/myid3 /opt/zookeeper/myid

#在node1-node3启动zookeeper
sudo docker exec node1 zkServer.sh start
sudo docker exec node2 zkServer.sh start
sudo docker exec node3 zkServer.sh start

#node2-4上启动journalnode
sudo docker exec node2 hadoop-daemon.sh start journalnode
sudo docker exec node3 hadoop-daemon.sh start journalnode
sudo docker exec node4 hadoop-daemon.sh start journalnode

#在node1上格式化
#hdfs namenode -format
sudo docker exec node1 hdfs namenode -format
#在node1上启动namenode
#hadoop-daemon.sh start namenode
sudo docker exec node1 hadoop-daemon.sh start namenode

#node2上执行
#hdfs namenode -bootstrapStandby
sudo docker exec node2 hdfs namenode -bootstrapStandby

#在node1上执行
#hdfs zkfc -formatZK
sudo docker exec node1 hdfs zkfc -formatZK
#sudo docker exec node1 start-dfs.sh

#====================================================================================
#停掉所有服务
sudo docker exec node2 hadoop-daemon.sh stop journalnode
sudo docker exec node3 hadoop-daemon.sh stop journalnode
sudo docker exec node4 hadoop-daemon.sh stop journalnode

sudo docker exec node1 hadoop-daemon.sh stop namenode

#停掉hdfs集群
#stop-dfs.sh
#sudo docker exec node1 stop-dfs.sh
#启动hadoop集群
sudo docker exec node1 start-dfs.sh
sudo docker exec node1 start-yarn.sh

#在node3和node4上执行yarn-daemon.sh start resourcemanager
sudo docker exec node3 yarn-daemon.sh start resourcemanager
sudo docker exec node4 yarn-daemon.sh start resourcemanager

#在node5上启动Hbase
sudo docker exec node5 start-hbase.sh


# get into hadoop node1 container
sudo docker exec -it node1 bash
