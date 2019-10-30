#!/bin/bash
set -ex
cd "$(dirname "$0")"

PYTHON_VERSION=${1:-3.7.4}
OS_VERSION="debian10.1"
VERSION=${PYTHON_VERSION}-${OS_VERSION}-0.0.2-20191029


echo "***** ${PYTHON_VERSION} *****"
docker build . --squash -t python_base:${VERSION} --build-arg IMAGE_VERSION=${VERSION} --build-arg IMAGE_NAME="python_base" --build-arg PYTHON_VERSION=${PYTHON_VERSION}
docker tag python_base:${VERSION} python_base:latest

docker login
docker tag python_base:${VERSION} koichiroiijima/python_base:${VERSION}
#docker tag python_base:${VERSION} koichiroiijima/python_base:latest
docker push koichiroiijima/python_base:${VERSION}
#docker push koichiroiijima/python_base:latest
