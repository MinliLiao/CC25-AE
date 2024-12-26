BENCHDIR := $(shell dirname -- "$(abspath "$(realpath "$MAKEFILE_LIST")")")
BENCHNAME = parsec.blackscholes
LLIB = -lm
EXTRACFLAGS = 
RUNCMD = ./${BENCHNAME}_bin 1 in_16K.txt prices.txt > benchmark.out
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
run: runnorm runnzdc comp
runnorm: ${BINDIRBASE}/${BENCHNAME}_bin
	cp ${BINDIRBASE}/${BENCHNAME}_bin ${BINDIRBASE}/../run/${BENCHNAME}_bin && \
	cd ${BINDIRBASE}/../run && \
	time -a -o time_base ${RUNCMD} && \
	mv benchmark.out benchmark.out.base && \
	mv prices.txt prices.txt.base
	
runnzdc: ${BINDIRNZDC}/${BENCHNAME}_bin
	cp ${BINDIRNZDC}/${BENCHNAME}_bin ${BINDIRNZDC}/../run/${BENCHNAME}_bin && \
	cd ${BINDIRNZDC}/../run && \
	time -a -o time_nzdc ${RUNCMD} && \
	mv benchmark.out benchmark.out.nzdc && \
	mv prices.txt prices.txt.nzdc

comp: ${BENCHDIR}/run/benchmark.out.base ${BENCHDIR}/run/benchmark.out.nzdc ${BENCHDIR}/run/prices.txt.base ${BENCHDIR}/run/prices.txt.nzdc
	diff ${BENCHDIR}/run/benchmark.out.base ${BENCHDIR}/run/benchmark.out.nzdc && \
	diff ${BENCHDIR}/run/prices.txt.base ${BENCHDIR}/run/prices.txt.nzdc
${BINDIRBASE}/${BENCHNAME}_bin: norm
${BINDIRNZDC}/${BENCHNAME}_bin: nzdc
${BENCHDIR}/run/benchmark.out.base ${BENCHDIR}/run/prices.txt.base: runnorm
${BENCHDIR}/run/benchmark.out.nzdc ${BENCHDIR}/run/prices.txt.nzdc: runnzdc