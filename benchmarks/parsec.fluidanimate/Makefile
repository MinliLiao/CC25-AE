BENCHDIR := $(shell dirname -- "$(abspath "$(realpath "$MAKEFILE_LIST")")")
BENCHNAME = parsec.fluidanimate
LLIB = -stdlib=libc++ -B/usr/lib/gcc/aarch64-linux-gnu/12/ -L/usr/lib/gcc/aarch64-linux-gnu/12/ -lc++ -lc++abi -lm
EXTRACFLAGS = -stdlib=libc++
RUNCMD = ./${BENCHNAME}_bin 1 5 in_100K.fluid out.fluid > benchmark.out 
CMPCMD = diff out.fluid ${REFOUTDIR}/out.fluid && diff benchmark.out ${REFOUTDIR}/benchmark.out
LLVMDIRBASE = ${BENCHDIR}/../../LLVM3.7.1_build/
LLVMDIRNZDC = ${BENCHDIR}/../../nZDC_build/
BINDIRBASE = ${BENCHDIR}/build_base
BINDIRNZDC = ${BENCHDIR}/build_nzdc

.PHONY: all norm nzdc
all: norm nzdc
norm: 
	BENCHNAME=${BENCHNAME} LLVMDIR=${LLVMDIRBASE} BINDIR=${BINDIRBASE} LLIB="${LLIB}" EXTRACFLAGS="${EXTRACFLAGS}" $(MAKE) -f Makefile.base $@
nzdc: 
	BENCHNAME=${BENCHNAME} LLVMDIR=${LLVMDIRNZDC} BINDIR=${BINDIRNZDC} LLIB="${LLIB}" EXTRACFLAGS="${EXTRACFLAGS}" $(MAKE) -f Makefile.base $@
.PHONY: clean cleannorm cleannzdc
clean: cleannorm cleannzdc
cleannorm:
	BENCHNAME=${BENCHNAME} LLVMDIR=${LLVMDIRBASE} BINDIR=${BINDIRBASE} $(MAKE) -f Makefile.base clean
cleannzdc:
	BENCHNAME=${BENCHNAME} LLVMDIR=${LLVMDIRNZDC} BINDIR=${BINDIRNZDC} $(MAKE) -f Makefile.base clean
.PHONY: run runnorm runnzdc
run: runnorm runnzdc
runnorm: ${BINDIRBASE}/${BENCHNAME}_bin
	cp ${BINDIRBASE}/${BENCHNAME}_bin ${BINDIRBASE}/../run/${BENCHNAME}_bin && \
	cd ${BINDIRBASE}/../run && \
	export LD_LIBRARY_PATH=${BENCHDIR}/../../LLVM3.7.1_build/lib:${LD_LIBRARY_PATH} && \
	time -a -o time_base ${RUNCMD} && \
	mv benchmark.out benchmark.out.base && \
	mv out.fluid out.fluid.base
	
runnzdc: ${BINDIRNZDC}/${BENCHNAME}_bin
	cp ${BINDIRNZDC}/${BENCHNAME}_bin ${BINDIRNZDC}/../run/${BENCHNAME}_bin && \
	cd ${BINDIRNZDC}/../run && \
	export LD_LIBRARY_PATH=${BENCHDIR}/../../LLVM3.7.1_build/lib:${LD_LIBRARY_PATH} && \
	time -a -o time_nzdc ${RUNCMD} && \
	mv benchmark.out benchmark.out.nzdc && \
	mv out.fluid out.fluid.nzdc

comp: ${BENCHDIR}/run/benchmark.out.base ${BENCHDIR}/run/benchmark.out.nzdc ${BENCHDIR}/run/out.fluid.base ${BENCHDIR}/run/out.fluid.nzdc
	diff ${BENCHDIR}/run/benchmark.out.base ${BENCHDIR}/run/benchmark.out.nzdc && \
	diff ${BENCHDIR}/run/out.fluid.base ${BENCHDIR}/run/out.fluid.nzdc
${BINDIRBASE}/${BENCHNAME}_bin: norm
${BINDIRNZDC}/${BENCHNAME}_bin: nzdc
${BENCHDIR}/run/benchmark.out.base ${BENCHDIR}/run/out.fluid.base: runnorm
${BENCHDIR}/run/benchmark.out.nzdc ${BENCHDIR}/run/out.fluid.nzdc: runnzdc