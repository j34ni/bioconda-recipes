#!/bin/bash

set -ex

export HIP_COMMON_DIR=hipamd
export HIPCC_BIN_DIR=$PREFIX/bin
export HIP_PLATFORM=amd

echo "6.3.2" > $HIP_COMMON_DIR/VERSION
ls -la $HIP_COMMON_DIR/VERSION
cat $HIP_COMMON_DIR/VERSION

if [ ! -e "$HIP_COMMON_DIR/include/hip/hip_runtime.h" ]; then
  mkdir -p $HIP_COMMON_DIR/include/hip
  ln -s amd_detail/amd_hip_runtime.h $HIP_COMMON_DIR/include/hip/hip_runtime.h
fi

cd $HIP_COMMON_DIR

mkdir -p build
cd build

cmake .. \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DHIP_COMMON_DIR=$HIP_COMMON_DIR \
  -DHIPCC_BIN_DIR=$HIPCC_BIN_DIR \
  -DROCM_PATH=$PREFIX \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_PREFIX_PATH="$PREFIX:$HIP_COMMON_DIR/include/hip/amd_detail:$HIP_COMMON_DIR/include/hip" \
  -DCMAKE_INCLUDE_PATH="$HIP_COMMON_DIR/include/hip/amd_detail:$HIP_COMMON_DIR/include/hip"

ninja
ninja install
