#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SPEC06_DIR=${SCRIPT_DIR}/spec06
BENCH_DIR=${SCRIPT_DIR}/benchmarks

# Get SPEC06
cd ${SCRIPT_DIR}
 mkdir specmnt
 mkdir ${SPEC06_DIR}
 sudo mount -o loop *.iso specmnt
 cp -a specmnt/* spec06/
 chmod u+w -R spec06
 sudo umount specmnt
 rm -r specmnt

# Setup source and run folders
cd ${BENCH_DIR}
for bench in 401.bzip2 429.mcf 456.hmmer 458.sjeng 462.libquantum 473.astar 400.perlbench 445.gobmk 464.h264ref 403.gcc 471.omnetpp 483.xalancbmk; do
    cp -r ${SPEC06_DIR}/benchspec/CPU2006/${bench}/src ${BENCH_DIR}/${bench}
    cp ${BENCH_DIR}/${bench}/Makefile* ${BENCH_DIR}/${bench}/src
    mkdir -p ${BENCH_DIR}/${bench}/run
    if [ -e ${SPEC06_DIR}/benchspec/CPU2006/${bench}/data/all/input ]; then
        cp -r ${SPEC06_DIR}/benchspec/CPU2006/${bench}/data/all/input ${BENCH_DIR}/${bench}/run
        mv ${BENCH_DIR}/${bench}/run/input/* ${BENCH_DIR}/${bench}/run
        rm -r ${BENCH_DIR}/${bench}/run/input
    fi
    cp -r ${SPEC06_DIR}/benchspec/CPU2006/${bench}/data/ref/input ${BENCH_DIR}/${bench}/run
    mv ${BENCH_DIR}/${bench}/run/input/* ${BENCH_DIR}/${bench}/run
    rm -r ${BENCH_DIR}/${bench}/run/input
done
