#!/bin/bash
set -ex

export CC=clang
export CXX=clang++

export ROCM_PATH=$PREFIX
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

cd hipamd

mkdir build
cd build

cmake -G Ninja \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DROCM_PATH=$PREFIX/opt/rocm \
      -DHIP_PLATFORM=amd \
      -DHIP_COMMON_DIR=$SRC_DIR \
      -DCLR_BUILD_HIP=ON \
      -DCLR_BUILD_OCL=OFF \
      -DCMAKE_C_COMPILER=$CC \
      -DCMAKE_CXX_COMPILER=$CXX \
      ..

ninja -j$(nproc)
ninja install
