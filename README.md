# CC25 Artifact Evaluation for Extended nZDC Fault Tolerance
This is the artifact for the artifact evaluation of CC 2025, for the paper "A Deep Technical Review of nZDC Fault Tolerance" by M. Liao, S. Ainsworth, L. Mukhanov and T. Jones. This artifact includes the nZDC-Compiler implementation (based on LLVM, original version at https://github.com/MPSLab-ASU/nZDC-Compiler) with our fix added as described in our CC 2025 paper and the scripts to download the benchmarks (where possible), compile them with vanilla LLVM and nZDC-Compiler with our fixes, and run them.

## Hardware requirements
An AArch64 machine (we used Neoverse-N1) with sudo access (to install dependencies and mount images), >2GB RAM for SPECint 2006 benchmarks, >12GB storage for PARSEC benchmarks.

## Software requirements
Linux system (we used Ubuntu 24.04.1 LTS) for compiling the LLVM, nZDC-Compiler with our fixes and PARSEC benchmarks. An image of the SPEC CPU2006 benchmarks is also required to run the SPEC06 benchmarks (not included in the artifact). 

## Build and Install
Download the artifact and cd to the root directory of this artifact, install the dependencies with
```
bash dependencies.sh
```

To get the vanilla LLVM and build build both the vanilla LLVM and nZDC-Compiler with our fixes:
```
bash build.sh
```

To get the PARSEC benchmarks and set up the directories to build and run them:
```
bash setup_parsec.sh
```

To work with SPEC06 benchmarks, put your image of the SPEC CPU2006 benchmarks in the root directory of this artifact, and then run
```
bash setup_spec06.sh
```

## Compiling and running
From the root directory of this artifact, to compile the PARSEC benchmarks with vanilla LLVM and nZDC-Compiler with our fixes and then run the two binaries to get timing
```
cd benchmarks
make run_parsec
```

To compile the SPECint benchmarks with vanilla LLVM and nZDC-Compiler with our fixes and then run the two binaries to get timing
```
make run_spec
```
Note that 445.gobmk is expected to compile and run successfully but is expected to exit *make run_spec* with error due to output difference.
The 403.gcc, 471.omnetpp, 483.xalancbmk benchmarks are expected to fail, but can be run individually with
```
make run_403.gcc
make run_471.omnetpp
make run_483.xalancbmk
```

## Collecting results
From the root directory of this artifact, to collect and print out the timing results
```
bash collect_results.sh
```
The produced result consists of the benchmark name, the execution time of the benchmark compiled with vanilla LLVM, the execution time of the benchmark compiled with nZDC-Compiler with our fix, and the slowdown of execution time with nZDC compared to vanilla.

## Expectations
All benchmarks except 403.gcc, 471.omnetpp and 483.xalancbmk should be able to compile and run to completion.
Collected results should show slowdown with trend similar to figure 8 in our paper, though the numbers are unlikely to match exactly due to experimental variance.

## Modifications and Extensions
