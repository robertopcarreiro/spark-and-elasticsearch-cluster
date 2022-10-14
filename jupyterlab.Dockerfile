FROM cluster-base

# -- Layer: JupyterLab

ARG spark_version=3.2.1
ARG jupyterlab_version=3.4.2

RUN apt-get update -y && \
    apt-get install -y python3-pip && \
    pip3 install wget pyspark==${spark_version} jupyterlab==${jupyterlab_version}

RUN pip3 install pyexcel \
    && pip3 install XlsxWriter \
    && pip3 install html5lib \
    && pip3 install lxml \
    && pip3 install koalas

# -- Runtime

EXPOSE 8888
WORKDIR ${SHARED_WORKSPACE}
CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=
