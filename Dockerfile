FROM niicloudoperation/notebook

USER root
RUN pip --no-cache-dir install jupyter-server-proxy

COPY jupyter_notebook_config.py /tmp/
USER $NB_USER

RUN cat /tmp/jupyter_notebook_config.py \
    >> ~/.jupyter/jupyter_notebook_config.py
