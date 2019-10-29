FROM koichiroiijima/debian_base:10.0-0.0.1-20190804

ARG IMAGE_NAME=python_base
ARG IMAGE_VERSION=3.7.4-debian10.0-0.0.1
ARG PYTHON_VERSION=3.7.4

LABEL \
    NAME=${IMAGE_NAME} \
    VERSION=${IMANGE_VERSION} \
    PYTHON_VERSION=${PYTHON_VERSION}
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PYENV_ROOT=/root/.pyenv
ENV PATH=/root/.pyenv/bin:/root/.pyenv/shims/:${PATH}
ENV ENV=/root/.bashrc
SHELL ["/bin/bash", "-c"]

# Install System Python
RUN set -ex \
    && \
    apt-get update \
    && \
    apt-get install  --no-install-recommends -y \
    python3 python3-pip \
    && \
    ln -sfn $(which python3) /usr/bin/python \
    && \
    ln -sfn $(which pip3) /usr/bin/pip \
    && \
    python --version \
    && \
    pip --version \
# Install pyenv
    && \
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
    && \
    echo 'eval "$(pyenv init -)"' >> /root/.bashrc \
    && \
    chmod +x /root/.bashrc \
    && \
    source /root/.bashrc \
    && \
    pyenv version \
# Install libraries
    && \
    apt-get install  --no-install-recommends -y \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl \
    git \
# Install Python from pyenv
    && \
    source /root/.bashrc \
    && \
    pyenv install ${PYTHON_VERSION} \
    && \
    pyenv global ${PYTHON_VERSION} \
    && \
    python --version \
# Install Python packages
    && \
    apt-get install  --no-install-recommends -y \
    libopenblas-base \
    libopenblas-dev \
    liblapack3 \
    libblas-dev \
    && \
    pip install -U --no-cache-dir pip \
    && \
    pip install -U --no-cache-dir \
    setuptools \
    wheel \
    pipenv \
    toml \
    PyYAML \
    && \
    pipenv run python --version \
    && \ 
    pip install -U --no-cache-dir \
    Cython \
    numpy \
    pandas \
    scipy \
    scikit-learn \
    pytest \
    pytest-cov \
    flake8 \
    flake8-docstrings \
    flake8-import-order \
    pep8-naming \
    pyformat \
    isort \
    redis \
    boto3 \
    Flask \
    PyYAML \
    jsonschema \
    jupyterlab \ 
    && \
    rm -rf ~/.cache/* \
    && \
    rm -rf ~/.pyenv/cache/* \
    && \
    apt-get autoclean \
    && \
    apt-get clean \
    && \
    rm -rf /var/lib/apt/lists/*

CMD ["python"]
