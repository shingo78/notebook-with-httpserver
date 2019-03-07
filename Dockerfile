FROM niicloudoperation/notebook

USER root
RUN pip --no-cache-dir install jupyter-server-proxy
RUN apt-get update && apt-get install -y tinyproxy && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY jupyter_notebook_config.py /tmp/
RUN mkdir -p /opt/tinyproxy/
COPY tinyproxy.conf.template /opt/tinyproxy/
COPY tinyproxy.sh /opt/tinyproxy/
RUN  chmod +x /opt/tinyproxy/tinyproxy.sh
USER $NB_USER

RUN cat /tmp/jupyter_notebook_config.py \
    >> ~/.jupyter/jupyter_notebook_config.py
