ARG BASE_IMAGE=bullseye-20211220-slim-20220102

FROM koichiroiijima/debian_base:${BASE_IMAGE}

ARG IMAGE_NAME=python_base
ARG IMAGE_VERSION=3.10.1-debian-bullseye-0.0.1
ARG PYTHON_VERSION=3.10.1

LABEL \
    NAME=${IMAGE_NAME} \
    VERSION=${IMANGE_VERSION} \
    PYTHON_VERSION=${PYTHON_VERSION}
ENV PYENV_ROOT=/root/.pyenv
ENV PATH=/root/.pyenv/bin:/root/.pyenv/shims/:/root/.local/bin:${PATH}
ENV PIPENV_VENV_IN_PROJECT=1

ENV PYENV_ROOT=/root/.pyenv
ENV PATH=/root/.pyenv/bin:/root/.pyenv/shims/:/root/.local/bin:${PATH}

# Install System Python
RUN set -ex \
    && \
    apt-get update \
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
    apt-get install --no-install-recommends -y \
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
# Install Python from pyenv
    && \
    pyenv install ${PYTHON_VERSION} \
    && \
    pyenv global ${PYTHON_VERSION} \
    && \
    python --version \
# Install Python packages
    && \
    pip install -U  --no-cache-dir pip \
    && \
    pip --version \
    && \
    pip install -U --no-cache-dir \
    setuptools \
    wheel \
    toml \
    && \
    pip install -U --no-cache-dir \
    PyYAML \
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
