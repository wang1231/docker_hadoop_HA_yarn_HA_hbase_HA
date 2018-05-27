FROM ubuntu

MAINTAINER wangsongbai <wangsongbai@szzt.com.cn>

WORKDIR /root

# install openssh-server, openjdk and wget
# RUN apt-get update && apt-get install -y openssh-server openjdk-7-jdk wget
RUN  apt-get  update && apt-get install net-tools  python openssh-server vim expect wget inetutils-ping  curl -y  && \
     apt-get  clean && \
     mkdir -p /usr/java


# install JDK
ADD  jdk-8u171-linux-x64.tar.gz /usr/java
# install hadoop 2.8.4
ADD  hadoop-2.8.4.tar.gz /home
# install zookeeper-3.4.12
ADD zookeeper-3.4.12.tar.gz /home
# install hbase-2.0.0
ADD hbase-2.0.0-bin.tar.gz /home


# set environment variable
ENV JAVA_HOME=/usr/java/jdk1.8.0_171
ENV PATH=$PATH:$JAVA_HOME/bin
ENV HADOOP_HOME=/home/hadoop-2.8.4
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV ZOOKEEPER_HOME=/home/zookeeper-3.4.12
ENV PATH=$PATH:$ZOOKEEPER_HOME/bin
ENV HBASE_HOME=/home/hbase-2.0.0
ENV PATH=$PATH:$HBASE_HOME/bin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

#创建文件夹
RUN mkdir -p /opt/zookeeper 
    #mkdir -p ~/hdfs/datanode && \
    #mkdir $HADOOP_HOME/logs

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/zoo.cfg $ZOOKEEPER_HOME/conf/ && \
    mv /tmp/backup-masters $HBASE_HOME/conf/ && \
    mv /tmp/hbase-env.sh $HBASE_HOME/conf/ && \
    mv /tmp/hbase-site.xml $HBASE_HOME/conf/ && \
    cp $HADOOP_HOME/etc/hadoop/hdfs-site.xml $HBASE_HOME/conf/ && \
    mv /tmp/regionservers $HBASE_HOME/conf/ && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/hadoop-daemon.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# format namenode
# RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]

