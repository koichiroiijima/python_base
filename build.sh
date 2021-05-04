#!/bin/bash
set -ex
cd "$(dirname "$0")"

BASE_IMAGE="bullseye-20210408-slim-20210504"
PYTHON_VERSION=${1:-3.9.4}
OS_VERSION="debian-bullseye"
VERSION=${PYTHON_VERSION}-${OS_VERSION}-0.0.5-20210504


echo "***** ${PYTHON_VERSION} *****"
docker build . -t python_base:${VERSION} --build-arg IMAGE_VERSION=${VERSION} --build-arg BASE_IMAGE=${BASE_IMAGE} --build-arg IMAGE_NAME="python_base" --build-arg PYTHON_VERSION=${PYTHON_VERSION}
docker tag python_base:${VERSION} python_base:latest

docker login
docker tag python_base:${VERSION} koichiroiijima/python_base:${VERSION}
#docker tag python_base:${VERSION} koichiroiijima/python_base:latest
docker push koichiroiijima/python_base:${VERSION}
#docker push koichiroiijima/python_base:latest
