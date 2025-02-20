#!/bin/bash

set -ex

export CC=clang
export CXX=clang++

mkdir build
cd build

cmake -G Ninja \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DROCM_PATH=$PREFIX \
    ..

ninja -j$(nproc)
ninja install
