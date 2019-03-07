FROM jupyter/scipy-notebook

USER root
RUN pip --no-cache-dir install jupyter-server-proxy papermill

# Configurations
RUN mkdir -p /usr/local/bin/before-notebook.d
COPY conf/deploy-config.sh /usr/local/bin/before-notebook.d/
RUN mkdir -p /opt/tinyproxy/ && \
    chmod +x /usr/local/bin/before-notebook.d/*.sh
COPY conf/jupyter_notebook_config.py /opt/tinyproxy/config.py
USER $NB_USER

# Test files
COPY tests/*.ipynb /tmp/
RUN mkdir /home/$NB_USER/tests && cp /tmp/*.ipynb /home/$NB_USER/tests/
