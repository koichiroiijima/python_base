#!/bin/bash
set -ex
cd "$(dirname "$0")"

export VERSION=3.7.3-alpine3.10-0.0.1-20190707
docker build . --squash -t python_base:${VERSION}
docker tag python_base:${VERSION} python_base:latest