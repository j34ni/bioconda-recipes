#!/bin/bash
set -ex

export CC=$(basename "$CC")
export CXX=$(basename "$CXX")

export ROCM_PATH=$PREFIX
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

cd $SRC_DIR/llvm

mkdir build
cd build

cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DROCM_PATH=$PREFIX \
    -DCMAKE_C_COMPILER=$CC \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" \
    -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INSTALL_UTILS=OFF \
    -DCMAKE_INSTALL_BINDIR=bin \
    -S .. \
    ..

ninja -j$(nproc)
ninja install
