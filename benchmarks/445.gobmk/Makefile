BENCHDIR := $(shell dirname -- "$(abspath "$(realpath "$MAKEFILE_LIST")")")
BENCHNAME = 445.gobmk
LLIB = -lm
EXTRACFLAGS = -DHAVE_CONFIG_H -I. -I.. -I../include -I./include
RUNCMD = ./${BENCHNAME}_bin --quiet --mode gtp < 13x13.tst > 13x13.out
REFOUTDIR = ${BENCHDIR}/../../spec06/benchspec/CPU2006/${BENCHNAME}/data/ref/output/
CMPCMD = diff 13x13.out ${REFOUTDIR}/13x13.out
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
	time -a -o time_base ${RUNCMD} && \
	${CMPCMD}
	
runnzdc: ${BINDIRNZDC}/${BENCHNAME}_bin
	cp ${BINDIRNZDC}/${BENCHNAME}_bin ${BINDIRNZDC}/../run/${BENCHNAME}_bin && \
	cd ${BINDIRNZDC}/../run && \
	time -a -o time_nzdc ${RUNCMD} && \
	${CMPCMD}
${BINDIRBASE}/${BENCHNAME}_bin: norm
${BINDIRNZDC}/${BENCHNAME}_bin: nzdc