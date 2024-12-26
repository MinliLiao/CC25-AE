#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
INSTALL_PREFIX=${SCRIPT_DIR}/install/
LLVM3_7_1_SRC=${SCRIPT_DIR}/llvm-project/
NZDC_SRC=${SCRIPT_DIR}/nZDC-Compiler/
LLVM3_7_1_BUILD=${SCRIPT_DIR}/LLVM3.7.1_build/
NZDC_BUILD=${SCRIPT_DIR}/nZDC_build/
# Get vanilla LLVM 
cd ${SCRIPT_DIR}
git clone https://github.com/llvm/llvm-project.git ${LLVM3_7_1_SRC}
# Checkout vanilla LLVM 3.7.1
cd ${LLVM3_7_1_SRC}
git checkout llvmorg-3.7.1
# Apply patch to make it work with newer python and gcc
git apply ${SCRIPT_DIR}/llvm3.7.1_fix.diff
# Setup for vanilla LLVM 3.7.1
mkdir -p ${INSTALL_PREFIX}
cd ${LLVM3_7_1_SRC}/llvm/tools/
ln -s ${LLVM3_7_1_SRC}/clang clang
cd ${LLVM3_7_1_SRC}/llvm/projects/
ln -s ${LLVM3_7_1_SRC}/libcxx libcxx
ln -s ${LLVM3_7_1_SRC}/libcxxabi libcxxabi
ln -s ${LLVM3_7_1_SRC}/libunwind libunwind
mkdir -p ${LLVM3_7_1_BUILD}
cd ${LLVM3_7_1_BUILD}
cmake -DLIBCXX_ENABLE_CXX1Y=true -DCMAKE_C_COMPILER=gcc-12 -DCMAKE_CXX_COMPILER=g++-12 -DCMAKE_C_FLAGS=-mno-outline-atomics -DCMAKE_CXX_FLAGS=-mno-outline-atomics -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} ${LLVM3_7_1_SRC}/llvm/
# Build vanilla LLVM 3.7.1
make -j 4
# Setup for building nZDC-Compiler
cd ${NZDC_SRC}/LLVM3.7/llvm/tools/
ln -s ${LLVM3_7_1_SRC}/clang clang
cd ${NZDC_SRC}/LLVM3.7/llvm/projects/
ln -s ${LLVM3_7_1_SRC}/libcxx libcxx
ln -s ${LLVM3_7_1_SRC}/libcxxabi libcxxabi
ln -s ${LLVM3_7_1_SRC}/libunwind libunwind
mkdir -p ${NZDC_BUILD}
cd ${NZDC_BUILD}
cmake -DLIBCXX_ENABLE_CXX1Y=true -DCMAKE_C_COMPILER=gcc-12 -DCMAKE_CXX_COMPILER=g++-12 -DCMAKE_C_FLAGS=-mno-outline-atomics -DCMAKE_CXX_FLAGS=-mno-outline-atomics -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} ${NZDC_SRC}/LLVM3.7/llvm/
# Build nZDC LLVM
make -j 4