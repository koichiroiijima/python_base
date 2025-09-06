#!/bin/bash
set -ex
cd "$(dirname "$0")"

VERSIONS=(
    3.13.6
)

for v in ${VERSIONS[*]}
do
    ./build.sh $v
done
