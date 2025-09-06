ARG BASE_IMAGE=bookworm-20250811-slim-20250813

FROM koichiroiijima/debian_base:${BASE_IMAGE}

ARG IMAGE_NAME=python_base
ARG IMAGE_VERSION=3.13.6-debian-bookworm-0.0.1
ARG PYTHON_VERSION=3.13.6

LABEL \
    NAME=${IMAGE_NAME} \
    VERSION=${IMANGE_VERSION} \
    PYTHON_VERSION=${PYTHON_VERSION}

ENV UV_ROOT=/root/.uv
ENV PATH=/root/.uv/bin:/root/.local/bin:${PATH}

# Install System Python
RUN set -ex \
    && \
    apt-get update \
    && \
    apt-get -y upgrade \
    && \
    apt-get -y dist-upgrade \
# Install uv
    && \
    curl -fsSL https://github.com/astral-sh/uv/releases/download/0.8.11/uv-installer.sh | sh \
    && \
    echo 'export PATH=/root/.uv/bin:$PATH' >> /root/.bashrc \
    && \
    chmod +x /root/.bashrc \
    && \
    source /root/.bashrc \
    && \
    uv --version \
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
# Install Python using uv
    && \
    uv python install  ${PYTHON_VERSION} \
    && \
    uv venv \
    && \
    source .venv/bin/activate \
    && \
    python --version \
# Install Python packages using uv
    && \
    uv pip install -U \
    setuptools \
    wheel \
    toml \
    PyYAML \
    && \
    rm -rf ~/.cache/* \
    && \
    rm -rf ${UV_ROOT}/cache/* \
    && \
    apt-get autoclean \
    && \
    apt-get clean \
    && \
    rm -rf /var/lib/apt/lists/*

CMD ["python"]
