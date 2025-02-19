#!/bin/bash

set -ex

export CC=clang
export CXX=clang++

export ROCM_PATH=$PREFIX
export HIP_PATH=$PREFIX
export HIP_CLANG_PATH=$PREFIX/bin
export HIP_LIB_PATH=$PREFIX/lib
export HIP_PLATFORM=amd
export HIP_COMPILER=clang

cd amd/hipcc

mkdir build

cd build

cmake -G Ninja \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DHIP_PLATFORM=$HIP_PLATFORM \
  -DHIP_COMPILER=$HIP_COMPILER \
  -DROCM_PATH=$ROCM_PATH \
  -DHIP_PATH=$HIP_PATH \
  -DHIP_CLANG_PATH=$HIP_CLANG_PATH \
  -DHIP_LIB_PATH=$HIP_LIB_PATH \
  -DROCM_VERSION=$ROCM_VERSION \
  ..

ninja -j$(nproc)

ninja install
