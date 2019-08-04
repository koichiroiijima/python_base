FROM koichiroiijima/alpine_base:3.10-0.0.2-20190729

ARG IMAGE_NAME=python_base
ARG IMAGE_VERSION=3.7.4-alpine3.10-0.0.2
ARG PYTHON_VERSION=3.7.4

LABEL \
    NAME=${IMAGE_NAME} \
    VERSION=${IMANGE_VERSION} \
    PYTHON_VERSION=${PYTHON_VERSION}

# Install System Python
RUN set -ex \
    && \
    apk add --no-cache --update \
        python3 \
    && \
    ln -sfn $(which python3) /usr/bin/python \
    && \
    ln -sfn $(which pip3) /usr/bin/pip \
    && \
    python --version \
    && \
    pip --version

# Install pyenv
ENV PYENV_ROOT=/root/.pyenv
ENV PATH=${PATH}:/root/.pyenv/bin
RUN set -ex \
    && \
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
    && \
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> /etc/.bashrc \
    && \
    source /etc/.bashrc \
    && \
    pyenv version

RUN set -ex \
    && \
    apk add --no-cache \
        libffi \
        "openssl<1.1" \
	bzip2 \
        zlib \
        readline \
        sqlite \
    && \
    apk add --no-cache --virtual .pyenv_build_deps \
        build-base \
        libffi-dev \
        "openssl-dev<1.1" \
        bzip2-dev \
        zlib-dev \
        readline-dev \
        sqlite-dev

# Install Python from pyenv
RUN set -ex \
    && \
    source /etc/.bashrc \
    && \
    pyenv install ${PYTHON_VERSION} \
    && \
    pyenv global ${PYTHON_VERSION} \
    && \
    python --version

# Install Python packages
RUN set -ex \
    && \
    source /etc/.bashrc \
    && \
    pyenv global ${PYTHON_VERSION} \
    && \
    python --version \
    && \
    apk add --no-cache openblas lapack \
    && \
    apk add --no-cache openblas-dev --virtual .pip_build_deps \
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
    pipenv install --python ${PYTHON_VERSION} \
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
        jupyterlab 

# Quick Fix
ENV ENV=/root/.bashrc
RUN set -ex \
    && \
    mv /etc/.bashrc /root/.bashrc

# Clean apk
RUN set -ex \
    && \
    apk del .pyenv_build_deps \
    && \
    apk del .pip_build_deps \
    && \
    apk cache clean \
    && \
    rm -rf ~/.cache/* \
    && \
    rm -rf ~/.pyenv/cache/* \
    && \
    rm -rf /var/cache/apk/*

CMD ["python"]
