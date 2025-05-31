#!/bin/bash
set -xe

# instructions from https://github.com/PDB-REDO/libcifpp#building
cmake ${CMAKE_ARGS} --trace-expand -S . -B build \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DBUILD_SHARED_LIBS=ON \
  -DINSTALL_LIBRARY=ON \
  -DBUILD_PYTHON_MODULE=ON \
  -DCMAKE_CXX_COMPILER=${CXX} \
  -DCMAKE_BUILD_TYPE=Release

cmake --build build
cmake --install build

# during cross compiling, the Python extension is incorrectly put in $BUILD_PREFIX
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" ]]; then
  ls ./build/lib
  cp ./build/lib/mkdssp.so ${SP_DIR}
fi

ctest --output-on-failure --test-dir build || true
