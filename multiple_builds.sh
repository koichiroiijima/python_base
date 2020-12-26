#!/bin/bash
set -ex
cd "$(dirname "$0")"

VERSIONS=(
    3.9.1
    3.8.6
    3.7.9
    3.6.12
)

for v in ${VERSIONS[*]}
do
    ./build.sh $v
done
