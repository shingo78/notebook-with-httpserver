FROM jupyter/scipy-notebook

USER root

# Python2
ENV CONDA2_DIR=/opt/conda2
RUN cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "4be03f925e992a8eda03758b72a77298 *Miniconda2-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda2-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA2_DIR && \
    rm Miniconda2-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    $CONDA2_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA2_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA2_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA2_DIR/bin/conda update --all --quiet --yes && \
    $CONDA2_DIR/bin/conda clean -tipsy && \
    fix-permissions $CONDA2_DIR

# Install IPython kernel
RUN $CONDA2_DIR/bin/conda install --quiet --yes \
    'ipython' \
    && $CONDA2_DIR/bin/conda clean -tipsy && \
    fix-permissions $CONDA2_DIR

# Install Python 2 packages
RUN $CONDA2_DIR/bin/conda install --quiet --yes \
    'conda-forge::blas=*=openblas' \
    'ipywidgets=7.4*' \
    'pandas=0.23*' \
    'numexpr=2.6*' \
    'matplotlib=2.2*' \
    'scipy=1.1*' \
    'seaborn=0.9*' \
    'scikit-learn=0.20*' \
    'scikit-image=0.14*' \
    'sympy=1.1*' \
    'cython=0.28*' \
    'patsy=0.5*' \
    'statsmodels=0.9*' \
    'cloudpickle=0.5*' \
    'dill=0.2*' \
    'dask=1.1.*' \
    'numba=0.38*' \
    'bokeh=0.13*' \
    'sqlalchemy=1.2*' \
    'hdf5=1.10*' \
    'h5py=2.7*' \
    'vincent=0.4.*' \
    'beautifulsoup4=4.6.*' \
    'protobuf=3.*' \
    'xlrd'  && \
    $CONDA2_DIR/bin/python -m ipykernel install && \
    $CONDA2_DIR/bin/conda remove --quiet --yes --force qt pyqt && \
    $CONDA2_DIR/bin/conda clean -tipsy && \
    fix-permissions $CONDA2_DIR

RUN pip --no-cache-dir install jupyter-server-proxy papermill
RUN apt-get update && apt-get install -y tinyproxy && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Utility
RUN pip --no-cache-dir install ansible && \
    apt-get update && apt-get install -y rsync openssh-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configurations
RUN mkdir -p /opt/tinyproxy/
COPY conf/jupyter_notebook_config.py /opt/tinyproxy/config.py

COPY conf/tinyproxy.conf.template /opt/tinyproxy/
COPY conf/tinyproxy.sh /opt/tinyproxy/
RUN  chmod +x /opt/tinyproxy/tinyproxy.sh && \
     cat /opt/tinyproxy/config.py >> /etc/jupyter/jupyter_notebook_config.py

USER $NB_USER

# Test files
COPY tests/*.ipynb /tmp/
RUN mkdir /home/$NB_USER/tests && cp /tmp/*.ipynb /home/$NB_USER/tests/

# Enable sudo command
ENV GRANT_SUDO=yes
