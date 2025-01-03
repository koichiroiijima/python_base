#!/bin/bash
set -ex
cd "$(dirname "$0")"

BASE_IMAGE="bookworm-20241223-slim-20241231"
PYTHON_VERSION=${1:-3.13.1}
OS_VERSION="debian-bookworm"
VERSION=${PYTHON_VERSION}-${OS_VERSION}-0.0.1-20241231

echo "***** ${PYTHON_VERSION} *****"
docker build . -t python_base:${VERSION} --build-arg IMAGE_VERSION=${VERSION} --build-arg BASE_IMAGE=${BASE_IMAGE} --build-arg IMAGE_NAME="python_base" --build-arg PYTHON_VERSION=${PYTHON_VERSION}
docker tag python_base:${VERSION} python_base:latest

docker login
docker tag python_base:${VERSION} koichiroiijima/python_base:${VERSION}
docker tag python_base:${VERSION} koichiroiijima/python_base:latest
docker push koichiroiijima/python_base:${VERSION}
docker push koichiroiijima/python_base:latest
