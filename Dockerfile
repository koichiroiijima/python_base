FROM koichiroiijima/alpine_base:3.10-0.0.2-20190727

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
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile \
    && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile \
    && \
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile \
    && \
    eval "$(pyenv init -)" \
    && \
    pyenv version

RUN set -ex \
    && \
    apk add --no-cache \
        libffi \
        openssl \
        bzip2 \
        zlib \
        readline \
        sqlite \
    && \
    apk add --no-cache --virtual .pyenv_build_deps \
        build-base \
        libffi-dev \
        openssl-dev \
        bzip2-dev \
        zlib-dev \
        readline-dev \
        sqlite-dev

# Install Python from pyenv
RUN set -ex \
    && \
    pyenv install ${PYTHON_VERSION} \
    && \
    pyenv global ${PYTHON_VERSION} \
    && \
    python --version

# Install Python packages
RUN set -ex \
    && \
    eval "$(pyenv init -)" \
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
    && \
    pipenv install --python ${PYTHON_VERSION} \
    && \
    pipenv run python --version \
    && \ 
    pipenv install \
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

# Clean apk
RUN set -ex \
    && \
    apk del .pyenv_build-deps .pip_build_deps \
    && \
    apk cache clean \
    && \
    rm -rf ~/.cache/* \
    && \
    rm -rf ~/.pyenv/cache/* \
    && \
    rm -rf /var/cache/apk/*

CMD ["pipenv run python"]
