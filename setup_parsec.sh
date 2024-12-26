#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PARSEC_GC=${SCRIPT_DIR}/parsec_gc
BENCH_DIR=${SCRIPT_DIR}/benchmarks

# Get PARSEC benchmarks with aarch64 support
cd ${SCRIPT_DIR}
git clone https://github.com/zhejianguk/parsec_gc.git ${PARSEC_GC}
cd ${PARSEC_GC}
git checkout aarch64_PURE
git apply ${SCRIPT_DIR}/parsec_gc_fix.diff

# Build and run PARSEC benchmarks default to get input files
./configure
source ./env.sh
mkdir -p ${PARSEC_GC}/run_dir
for bench in blackscholes dedup fluidanimate freqmine streamcluster swaptions ; do
    parsecmgmt -a build -p ${bench}
    parsecmgmt -a run -p ${bench} -i simmedium -n 1 -d ${PARSEC_GC}/run_dir
done

# Setup folders for compiling with nZDC
for bench in blackscholes fluidanimate freqmine swaptions ; do
    cp -r ${PARSEC_GC}/pkgs/apps/${bench}/src ${BENCH_DIR}/parsec.${bench}
    cp -r ${PARSEC_GC}/run_dir/pkgs/apps/${bench}/run ${BENCH_DIR}/parsec.${bench}
done
for bench in dedup streamcluster ; do
    cp -r ${PARSEC_GC}/pkgs/kernels/${bench}/src ${BENCH_DIR}/parsec.${bench}
    cp -r ${PARSEC_GC}/run_dir/pkgs/kernels/${bench}/run ${BENCH_DIR}/parsec.${bench}
done
for bench in ssl zlib ; do
    cp -r ${PARSEC_GC}/pkgs/libs/${bench}/src ${BENCH_DIR}/parsec.${bench}
done
for bench in blackscholes dedup fluidanimate freqmine streamcluster swaptions ssl zlib; do
    cp ${BENCH_DIR}/parsec.${bench}/Makefile* ${BENCH_DIR}/parsec.${bench}/src
done
cp ${PARSEC_GC}/pkgs/libs/ssl/obj/aarch64-linux.gcc/crypto/buildinf.h ${BENCH_DIR}/parsec.ssl/src/crypto