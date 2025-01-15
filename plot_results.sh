#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BENCH_DIR=${SCRIPT_DIR}/benchmarks
SPEC_BENCHS=(400.perlbench 401.bzip2 429.mcf 445.gobmk 456.hmmer 458.sjeng 462.libquantum 464.h264ref 473.astar)
PARSEC_BENCHS=(parsec.blackscholes parsec.dedup parsec.fluidanimate parsec.freqmine parsec.streamcluster parsec.swaptions)

./collect_results.sh > COLLECTED_results.txt

gnuplot ./plot_results.gp
