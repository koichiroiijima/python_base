ARG BASE_IMAGE=bookworm-20251208-slim-20251229

FROM koichiroiijima/debian_base:${BASE_IMAGE}

ARG IMAGE_NAME=python_base
ARG IMAGE_VERSION=3.14.2-debian-bookworm-0.0.1
ARG PYTHON_VERSION=3.14.2
ARG UV_VERSION=0.9.18
ARG USERNAME=appuser
ARG USER_ID=1000
ARG GROUP_ID=1000

LABEL \
    NAME=${IMAGE_NAME} \
    VERSION=${IMAGE_VERSION} \
    PYTHON_VERSION=${PYTHON_VERSION}

USER root
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENV UV_ROOT=/home/${USERNAME}/.uv
ENV VIRTUAL_ENV=/home/${USERNAME}/opt/.venv
ENV PATH=${VIRTUAL_ENV}/bin:/home/${USERNAME}/.uv/bin:/home/${USERNAME}/.local/bin:${PATH}

RUN set -ex \
    && \
    apt-get update \
    && \
    apt-get install --no-install-recommends -y \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    && \
    apt-get autoremove -y \
    && \
    apt-get autoclean -y \
    && \
    apt-get clean -y

USER ${USERNAME}
WORKDIR /home/${USERNAME}/opt/
# Install Python using uv 
RUN set -ex \
    # Install uv
    && \
    curl -fsSL https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-installer.sh | sh \
    && \
    echo 'export PATH=/home/${USERNAME}/.uv/bin:$PATH' >> /home/${USERNAME}/.bashrc \
    && \
    chmod +x /home/${USERNAME}/.bashrc \
    && \
    source /home/${USERNAME}/.bashrc \
    && \
    uv --version \
    && \
    uv python install ${PYTHON_VERSION} \
    && \
    uv venv \
    # Install packages into the created venv using uv's pip wrapper
    && \
    uv pip install -U pip setuptools wheel toml PyYAML dotenv\
    && \
    rm -rf ~/.cache/* \
    && \
    rm -rf ${UV_ROOT}/cache/*

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["python"]
