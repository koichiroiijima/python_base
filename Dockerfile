ARG BASE_IMAGE=bullseye-20210408-slim-20210504

FROM koichiroiijima/debian_base:${BASE_IMAGE}

ARG IMAGE_NAME=python_base
ARG IMAGE_VERSION=3.9.4-debian-bullseye-0.0.1
ARG PYTHON_VERSION=3.9.4

LABEL \
    NAME=${IMAGE_NAME} \
    VERSION=${IMANGE_VERSION} \
    PYTHON_VERSION=${PYTHON_VERSION}
ENV PYENV_ROOT=/root/.pyenv
ENV PATH=/root/.pyenv/bin:/root/.pyenv/shims/:/root/.local/bin:${PATH}
ENV PIPENV_VENV_IN_PROJECT=1

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
    echo 'eval "$(/root/.pyenv/bin/pyenv init -)"' >> /root/.bashrc \
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
    && \
    echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list.d/stretch.list \
    && \
    echo "deb http://httpredir.debian.org/debian stretch main contrib non-free" >> /etc/apt/sources.list.d/stretch.list \
    && \
    echo "deb-src http://httpredir.debian.org/debian stretch main contrib non-free" >> /etc/apt/sources.list.d/stretch.list \
    && \
    echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list.d/stretch.list \
    && \
    apt-get update \
    && \
    apt-get install --no-install-recommends -y \
	libssl1.0-dev \
# Install Python from pyenv
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
    matplotlib \
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
