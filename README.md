# Dockerfile for running Spark job with AstraDB

The Spark Cassandra Connector (SCC) lets you process DataStax Astra DB data with Apache Spark. See the step-by-step SCC guide here:  
[https://docs.datastax.com/en/astra-db-serverless/databases/connect-apache-spark.html](https://docs.datastax.com/en/astra-db-serverless/databases/connect-apache-spark.html)  

This repo packages the setup into a Dockerfile for easy environment creation with one Docker command.

## Verified Versions
The following versions have been tested and confirmed to work with this setup:  
- **Scala**: 2.12  
- **Spark**: 3.5.5  
- **Spark Cassandra Connector**: 3.5.1  
- **Hadoop**: 3  


# How to build and run

### 1. Clone the repository

```shell
git clone https://github.com/harusametime/astradb-spark-dockerfile.git
```
### 2. Download Secure Connect Bundle

For non-vector Astra DB, find the download link in the "Connect" tab:

![image](https://github.com/user-attachments/assets/26d2fc8f-7c6f-4d7f-838a-bc4141e7950a)

Please place the zip file in the directory `scb`. 

### 3. Create a Config File

Create spark-defaults.conf in the repo root with this template (update the zip filename):  


```yaml
spark.files /scb/secure-connect-nonvector-db.zip
spark.cassandra.connection.config.cloud.path secure-connect-nonvector-db.zip
spark.cassandra.auth.username token
spark.cassandra.auth.password <Token Here>
spark.dse.continuousPagingEnabled false
spark.driver.extraClassPath /usr/local/spark/jars/*:/root/.ivy2/jars/*
spark.executor.extraClassPath /usr/local/spark/jars/*:/root/.ivy2/jars/*
```
This requires application token in <Token Here>, which can be found above the download link to secure connect bundle.

![image](https://github.com/user-attachments/assets/60ebc188-8627-414b-ae9e-76d3a11eda1e)

###  4. Verify Your File Structure

```
astradb-spark-dockerfile
├── Dockerfile
├── scb
│   └── secure-connect-nonvector-db.zip (need to change the name to your file name)
└── spark-defaults.conf
```

### 5. Build the Docker Image

```shell
docker build ./ -t astradb-spark
```

### 6. Run and Access Spark Shell


```shell 
docker run -it astradb-spark /bin/bash
```

You'll see the following messages.

```shell
25/04/10 13:52:26 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
Spark context Web UI available at http://25e179df1661:4040
Spark context available as 'sc' (master = local[*], app id = local-1744293149438).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.5.5
      /_/
         
Using Scala version 2.12.18 (OpenJDK 64-Bit Server VM, Java 1.8.0_342)
Type in expressions to have them evaluated.
Type :help for more information.

scala> 
```

### 7. Try a Spark job

If you created keyspace named `default_keyspace` when creating Astra DB and created table named `sample_table`, you can load data by `val df = spark.read.cassandraFormat("sample_table", "default_keyspace").load()`.

![image](https://github.com/user-attachments/assets/1dd29418-be64-46dd-8c91-66af8a88d86a)
