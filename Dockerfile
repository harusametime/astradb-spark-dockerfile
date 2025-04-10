# Use the official OpenJDK image from Docker Hub
FROM openjdk:8-jdk

# Set the environment variables
ENV SCALA_VERSION=2.12
ENV SPARK_VERSION=3.5.5
ENV SPARK_CASSANDRA_CONNECTOR_VERSION=3.5.1
ENV HADOOP_VERSION=3
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$SPARK_HOME/bin:$PATH

# Install necessary dependencies
RUN apt-get update && apt-get install -y wget && apt-get clean

# Download and extract Apache Spark
RUN wget https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
    && tar xzvf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
    && mv spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION /usr/local/spark \
    && rm spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz

# RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
#     && tar xzvf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
#     && mv spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION /usr/local/spark \
#     && rm spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz


# Download Spark Cassandra Connector and its dependencies
RUN wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/com/datastax/spark/spark-cassandra-connector_$SCALA_VERSION/$SPARK_CASSANDRA_CONNECTOR_VERSION/spark-cassandra-connector_$SCALA_VERSION-$SPARK_CASSANDRA_CONNECTOR_VERSION.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/com/datastax/spark/spark-cassandra-connector-driver_$SCALA_VERSION/$SPARK_CASSANDRA_CONNECTOR_VERSION/spark-cassandra-connector-driver_$SCALA_VERSION-$SPARK_CASSANDRA_CONNECTOR_VERSION.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/org/apache/cassandra/java-driver-core-shaded/4.18.1/java-driver-core-shaded-4.18.1.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/com/datastax/oss/native-protocol/1.5.1/native-protocol-1.5.1.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/com/datastax/oss/java-driver-shaded-guava/25.1-jre-graal-sub-1/java-driver-shaded-guava-25.1-jre-graal-sub-1.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/org/apache/cassandra/java-driver-mapper-runtime/4.18.1/java-driver-mapper-runtime-4.18.1.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/org/apache/cassandra/java-driver-query-builder/4.18.1/java-driver-query-builder-4.18.1.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.10/commons-lang3-3.10.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/com/thoughtworks/paranamer/paranamer/2.8/paranamer-2.8.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/org/scala-lang/scala-reflect/2.12.19/scala-reflect-2.12.19.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/com/typesafe/config/1.4.1/config-1.4.1.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.26/slf4j-api-1.7.26.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/io/dropwizard/metrics/metrics-core/4.1.18/metrics-core-4.1.18.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/org/hdrhistogram/HdrHistogram/2.1.12/HdrHistogram-2.1.12.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/org/reactivestreams/reactive-streams/1.0.3/reactive-streams-1.0.3.jar \
    && wget -P $SPARK_HOME/jars https://repo1.maven.org/maven2/org/scala-lang/modules/scala-collection-compat_2.12/2.11.0/scala-collection-compat_2.12-2.11.0.jar

# Copy configuration files into the container
COPY spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf

# Copy Secure Connect bundle
COPY ./scb/secure-connect-nonvector-db.zip /scb/secure-connect-nonvector-db.zip

# Set the entrypoint directly in Dockerfile
ENTRYPOINT ["spark-shell"]
