FROM koichiroiijima/alpine_base:3.10-0.0.1-20190707

LABEL \
    NAME=python \
    VERSION=3.7-alpine3.10-0.0.1-20190707

# Install Python
RUN set -ex \
    && \
    apk add --no-cache --update \
        python3 \
        python3-dev \
        lapack \
        openblas \
    && \
    apk add --no-cache --update --virtual .build-deps \
        lapack-dev

RUN set -ex \
    && \
    ln -sfn $(which python3) /usr/bin/python \
    && \
    ln -sfn $(which pip3) /usr/bin/pip \
    && \
    python --version \
    && \
    pip --version

# Install Python packages
RUN set -ex \
    && \
    pip install -U --no-cache-dir pip \
    && \
    pip install -U --no-cache-dir \
        setuptools \
        wheel \
        pipenv
RUN set -ex \
    && \
    pipenv install --python 3.7.3 \
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
    apk del .build-deps \
    && \
    apk cache clean \
    && \
    rm -rf ~/.cache/ \
    && \
    rm -rf /var/cache/apk/*

CMD ["python"]