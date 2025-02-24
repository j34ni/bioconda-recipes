#!/bin/bash
set -ex

export CC=$(basename "$CC")
export CXX=$(basename "$CXX")

export CLR_DIR=$SRC_DIR/clr
export HIP_DIR=$SRC_DIR/hip

export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

mkdir -p $HIP_DIR/build

cd $CLR_DIR

mkdir build
cd build

cmake -G Ninja \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DHIP_COMMON_DIR=$HIP_DIR \
      -DHIP_PLATFORM=amd \
      -DCMAKE_BUILD_TYPE=Release \
      -DHIP_CATCH_TEST=0 \
      -DCLR_BUILD_HIP=ON \
      -DCLR_BUILD_OCL=OFF \
      -DCMAKE_C_COMPILER=$CC \
      -DCMAKE_CXX_COMPILER=$CXX \
      -DHIPCC_BUILD_DIR=$HIP_DIR/build \
      ..

ninja -j$(nproc)
ninja install
