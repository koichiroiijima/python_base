#!/bin/bash
set -ex
cd "$(dirname "$0")"

VERSIONS=(
    3.13.1
    3.12.8
    3.11.11
    3.10.15
    3.9.21
)

for v in ${VERSIONS[*]}
do
    ./build.sh $v
done
