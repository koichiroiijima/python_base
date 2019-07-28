#!/bin/bash
set -ex
cd "$(dirname "$0")"

PYTHON_VERSION=${PYTHON_VERSION:-3.7.4}
ALPINE_VERSION="alpine3.10"
VERSION=${PYTHON_VERSION}-${ALPINE_VERSION}-0.0.2-20190727

docker build . --squash -t python_base:${VERSION} --build-arg IMAGE_VERSION=${VERSION} --build-arg IMAGE_NAME="python_base" --build-arg PYTHON_VERSION=${PYTHON_VERSION}
docker tag python_base:${VERSION} python_base:latest

docker login
docker tag python_base:${VERSION} koichiroiijima/python_base:${VERSION}
docker tag python_base:${VERSION} koichiroiijima/python_base:latest
docker push koichiroiijima/python_base:${VERSION}
docker push koichiroiijima/python_base:latest