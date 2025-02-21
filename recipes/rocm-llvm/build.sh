#!/bin/bash

set -ex

mkdir -p build

cd build

cmake ../llvm \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DLLVM_ENABLE_PROJECTS="clang;lld;compiler-rt" \
  -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" \
  -DLLVM_ENABLE_ASSERTIONS=OFF \
  -DLLVM_ENABLE_DOXYGEN=OFF \
  -DLLVM_ENABLE_SPHINX=OFF \
  -DLLVM_INCLUDE_DOCS=OFF

ninja -j"${CPU_COUNT}"

ninja install
