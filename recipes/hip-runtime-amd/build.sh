#!/bin/bash
set -ex

export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
export HIP_COMMON_DIR=$CONDA_PREFIX/opt/rocm/include/hip

cd hipamd

mkdir build
cd build

cmake -G Ninja \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DROCM_PATH=$PREFIX/opt/rocm \
      -DHIP_PLATFORM=amd \
      -DHIP_COMMON_DIR=$HIP_COMMON_DIR \
      -DCLR_BUILD_HIP=ON \
      -DCLR_BUILD_OCL=OFF \
      -DCMAKE_C_COMPILER=$CONDA_PREFIX/bin/clang \
      -DCMAKE_CXX_COMPILER=$CONDA_PREFIX/bin/clang++ \
      -DCLANG_RESOURCE_DIR=$CONDA_PREFIX/lib/clang/18 \
      -DHIP_CXX_FLAGS="-I$HIP_COMMON_DIR" \
      -DHIP_C_FLAGS="-I$HIP_COMMON_DIR" \
      ..

ninja -j$(nproc)
ninja install
