#!/bin/bash

set -ex

mkdir -p build

cd build

cmake .. \
  -G Ninja \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DROCM_VERSION="$PKG_VERSION" \
  -DBUILD_DOCS=OFF

ninja -j$(nproc)

ninja install
