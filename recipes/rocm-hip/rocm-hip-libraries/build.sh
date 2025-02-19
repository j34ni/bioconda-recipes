#!/bin/bash

set -ex

export CLR_DIR=clr
export HIP_DIR=hip
export HIPCC_BIN_DIR=$PREFIX/bin

cd "$CLR_DIR"

mkdir -p build

cd build

cmake -DHIP_COMMON_DIR=$HIP_DIR \
      -DHIP_PLATFORM=amd \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DHIP_CATCH_TEST=0 \
      -DCLR_BUILD_HIP=ON \
      -DCLR_BUILD_OCL=OFF \
      -DHIPCC_BIN_DIR=$HIPCC_BIN_DIR \
      ..

make -j$(nproc)

make install
