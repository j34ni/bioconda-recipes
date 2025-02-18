#!/bin/bash

set -ex

mkdir -p build

cd build

cmake -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" \
  -DLLVM_ENABLE_ASSERTIONS=OFF \
  -DHIP_COMPILER=clang \
  -DHIP_PLATFORM=amd \
  -DCMAKE_CXX_STANDARD=17 \
  -DBUILD_SHARED_LIBS=ON \
  ..

ninja -j$(nproc)

ninja install
