#!/bin/bash
set -ex
cd "$(dirname "$0")"

VERSIONS=(
    3.10.1
    3.9.4
    3.8.9
    3.7.10
    3.6.13
)

for v in ${VERSIONS[*]}
do
    ./build.sh $v
done
