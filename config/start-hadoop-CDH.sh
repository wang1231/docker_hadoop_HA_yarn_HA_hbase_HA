#!/bin/bash

echo -e "关闭dfs\n"

$HADOOP_HOME/sbin/stop-dfs.sh

echo -e "关闭yarn\n"

$HADOOP_HOME/sbin/stop-yarn.sh

echo -e "node3上关闭resourcemanager\n"

ssh node3 "$HADOOP_HOME/sbin/yarn-daemon.sh stop resourcemanager"

echo -e "node3上关闭historyserver\n"
ssh node3 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh stop historyserver"

echo -e "node4上关闭resourcemanager\n"

ssh node4 "$HADOOP_HOME/sbin/yarn-daemon.sh stop resourcemanager"

echo -e "开启dfs\n"

$HADOOP_HOME/sbin/start-dfs.sh

echo -e "开启yarn\n"

$HADOOP_HOME/sbin/start-yarn.sh

echo -e "node3上启动resourcemanager\n"
ssh node3 "$HADOOP_HOME/sbin/yarn-daemon.sh start resourcemanager"

echo -e "node3上启动historyserver\n"
ssh node3 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh  start historyserver"

echo -e "node4启动resourcemanager\n"
ssh node4 "$HADOOP_HOME/sbin/yarn-daemon.sh start resourcemanager"





