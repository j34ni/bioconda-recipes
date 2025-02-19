#!/bin/bash

set -ex

export CC=clang
export CXX=clang++

export ROCM_PATH=$PREFIX
export ROCM_DIR=$PREFIX

mkdir build

cd build

cmake -G Ninja \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    ..

ninja -j$(nproc)

ninja install
