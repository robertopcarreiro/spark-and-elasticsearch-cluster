# geolink-server
 Ambiente de produção em servidor standalone para equipe de GeoLinkage na sala segura.


## Melhorar a performance do servidor

O script abaixo só deverá ser executado - uma única vez - na instalação do servidor.

```bash
./env_tunning.sh
```

## Iniciar o ambiente analítico

Para subir os componentes do ambiente é utilizado docker-compose abaixo:

```bash
docker-compose up -d
```
Uma vez executado o scrips as portas dos serviços serão:

* 8888: Jupiter notebook
* 8080: Spark master
* 8081: Spark worker1
* 8082: Spark worker2
* 8083: Spark worker3
* 8084: Spark worker4
* 8085: Spark worker5
* 9200: Elasticsearch HTTP
* 9300: Elasticsearch TCP transport
* 5000: ElastickHQ

## Cluster Spark

### Criar as imagens customizadas

O script abaixo cria as imagens customizadas que serão utilizadas pelo cluster. As versões utilizadas são:
* SPARK 3.2.1
* HADOOP 3.2
* JUPYTERLAB 3.4.2
* PYTHON 3.9.2

Para criar as imagens execute:

```bash
./build.sh
```

### Config do Cluster Spark

Após iniciar o cluster utilizando o comando docker-compose. O cluster padrão - que pode ser ajustado as necessidades posteriormente - possui um node MASTER e 5 nodes WORKERS. Cada node WORKER possui a seguinte configuração:
* CORES=8
* MEMORY=32G



### Acessar o Cluster Spark

Para verifica o funcionamento do cluster spark devem ser utilizadas as portas:

* [IP do servidor]:8080 - Spark master
* [IP do servidor]:8081 - Spark worker 1
* [IP do servidor]:8082 - Spark worker 2
* [IP do servidor]:8083 - Spark worker 3
* [IP do servidor]:8084 - Spark worker 4
* [IP do servidor]:8085 - Spark worker 5

Ex.: http://172.16.15.251:8080/
## JupyterLab
O JupyterLab pode ser acessado a porta 8888. Assim, acessar:

* [IP do servidor]:8888 - JupyterLab 1

No ambiente somente há um único JupyterLab, caso seja necessário mais instâncias o arquivo docker-compose.ylm precisa ser editado.

Ex.: http://172.16.15.251:8888/

### Teste do JupyterLab

Há no repositório um notebook python para teste (test.ipynb ) do funcionamento do JupyterLab + Spark Cluster. Abaixo trecho do script:

```python
spark_conf = SparkConf()
spark_conf.setAll([
    ('spark.master', 'spark://spark-master:7077'),
    ('spark.app.name', 'pyspark-notebook.cidacs'),
    ('spark.submit.deployMode', 'client'),
    ('spark.ui.showConsoleProgress', 'true'),
    ('spark.eventLog.enabled', 'false'),
    ('spark.logConf', 'false'),
    ('spark.driver.bindAddress', 'jupyterlab'),
    ('spark.driver.host', 'jupyterlab'),
    ('spark.executor.memory', '512m'),
])
```

## ElasticHQ

Para acessar a interface web do ElasticHQ acessar a porta 5000. Assim, informe no navegador:

* [IP do servidor]:5000 - ElasticHQ

Ex.: http://172.16.15.251:5000/
## Parar e reiniciar ambiente analítico

Para PARAR o ambiente no diretório geolink-server executar:

```bash
docker-compose stop
```

Para REINICIAR o ambiente no diretório geolink-server executar:

```bash
docker-compose start
```

Ao executar esses comandos todos os arquivos e configurações são mantidas, apenas os serviços são afetados.


## Sobre os containers no servidor

Listar containers em execução:

```bash
geolink@geolinkage-172-16-15-251:~/geolink-server$ docker ps
CONTAINER ID   IMAGE                                                 COMMAND                  CREATED         STATUS          PORTS                                                                                  NAMES
c55381f624bd   elastichq/elasticsearch-hq                            "supervisord -c /etc…"   2 minutes ago   Up 49 seconds   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp                                              elastic-hq
e80b4e4c7a69   spark-worker                                          "/bin/sh -c 'bin/spa…"   2 minutes ago   Up 49 seconds   0.0.0.0:8082->8081/tcp, :::8082->8081/tcp                                              spark-worker-2
bd07c25c9879   spark-worker                                          "/bin/sh -c 'bin/spa…"   2 minutes ago   Up 49 seconds   0.0.0.0:8083->8081/tcp, :::8083->8081/tcp                                              spark-worker-3
b2ac4d629580   spark-worker                                          "/bin/sh -c 'bin/spa…"   2 minutes ago   Up 49 seconds   0.0.0.0:8084->8081/tcp, :::8084->8081/tcp                                              spark-worker-4
eb864191dea5   spark-worker                                          "/bin/sh -c 'bin/spa…"   2 minutes ago   Up 50 seconds   0.0.0.0:8081->8081/tcp, :::8081->8081/tcp                                              spark-worker-1
4fa9c42d08a5   spark-worker                                          "/bin/sh -c 'bin/spa…"   2 minutes ago   Up 49 seconds   0.0.0.0:8085->8081/tcp, :::8085->8081/tcp                                              spark-worker-5
95e0d9a61ba3   spark-master                                          "/bin/sh -c 'bin/spa…"   2 minutes ago   Up 50 seconds   0.0.0.0:7077->7077/tcp, :::7077->7077/tcp, 0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   spark-master
2668aafa895c   jupyterlab                                            "/bin/sh -c 'jupyter…"   2 minutes ago   Up 50 seconds   0.0.0.0:8888->8888/tcp, :::8888->8888/tcp                                              jupyterlab
f1ada48dee99   docker.elastic.co/elasticsearch/elasticsearch:7.7.0   "/tini -- /usr/local…"   2 minutes ago   Up 50 seconds   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   elasticsearch
```


