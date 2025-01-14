#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BENCH_DIR=${SCRIPT_DIR}/benchmarks
SPEC_BENCHS=(400.perlbench 401.bzip2 429.mcf 445.gobmk 456.hmmer 458.sjeng 462.libquantum 464.h264ref 473.astar)
PARSEC_BENCHS=(parsec.blackscholes parsec.dedup parsec.fluidanimate parsec.freqmine parsec.streamcluster parsec.swaptions)

echo "benchmark time_base time_nzdc slowdown"
for bench in ${SPEC_BENCHS[@]} ${PARSEC_BENCHS[@]}; do
    BASETIME=$(grep user ${BENCH_DIR}/${bench}/run/time_base | awk -F'u' '{a=$1} END{print a}')
    NZDCTIME=$(grep user ${BENCH_DIR}/${bench}/run/time_nzdc | awk -F'u' '{a=$1} END{print a}')
    SLOWDOWN=$(awk -v base=${BASETIME} -v  nzdc=${NZDCTIME} 'BEGIN{print ( nzdc/base )}')
    echo ${bench} ${BASETIME} ${NZDCTIME} ${SLOWDOWN}
done