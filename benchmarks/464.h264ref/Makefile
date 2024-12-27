BENCHDIR := $(shell dirname -- "$(abspath "$(realpath "$MAKEFILE_LIST")")")
BENCHNAME = 464.h264ref
LLIB = -lm
EXTRACFLAGS = 
RUNCMD = ./${BENCHNAME}_bin -d foreman_ref_encoder_baseline.cfg > foreman_ref_baseline_encodelog.out
REFOUTDIR = ${BENCHDIR}/../../spec06/benchspec/CPU2006/${BENCHNAME}/data/ref/output/
CMPCMD = diff foreman_ref_baseline_leakybucketparam.cfg ${REFOUTDIR}/foreman_ref_baseline_leakybucketparam.cfg && diff foreman_ref_baseline_encodelog.out ${REFOUTDIR}/foreman_ref_baseline_encodelog.out 
LLVMDIRBASE = ${BENCHDIR}/../../LLVM3.7.1_build/
LLVMDIRNZDC = ${BENCHDIR}/../../nZDC_build/
BINDIRBASE = ${BENCHDIR}/build_base
BINDIRNZDC = ${BENCHDIR}/build_nzdc

# same conditional branch out of range thing as gobmk

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
	mv foreman_ref_baseline_leakybucketparam.cfg foreman_ref_baseline_leakybucketparam.cfg.base && \
	mv foreman_ref_baseline_encodelog.out foreman_ref_baseline_encodelog.out.base
	
runnzdc: ${BINDIRNZDC}/${BENCHNAME}_bin
	cp ${BINDIRNZDC}/${BENCHNAME}_bin ${BINDIRNZDC}/../run/${BENCHNAME}_bin && \
	cd ${BINDIRNZDC}/../run && \
	time -a -o time_nzdc ${RUNCMD} && \
	mv foreman_ref_baseline_leakybucketparam.cfg foreman_ref_baseline_leakybucketparam.cfg.nzdc && \
	mv foreman_ref_baseline_encodelog.out foreman_ref_baseline_encodelog.out.nzdc

comp: ${BENCHDIR}/run/foreman_ref_baseline_leakybucketparam.cfg.base ${BENCHDIR}/run/foreman_ref_baseline_leakybucketparam.cfg.nzdc ${BENCHDIR}/run/foreman_ref_baseline_encodelog.out.base ${BENCHDIR}/run/foreman_ref_baseline_encodelog.out.nzdc
	diff ${BENCHDIR}/run/foreman_ref_baseline_leakybucketparam.cfg.base ${BENCHDIR}/run/foreman_ref_baseline_leakybucketparam.cfg.nzdc && \
	diff ${BENCHDIR}/run/foreman_ref_baseline_encodelog.out.base ${BENCHDIR}/run/foreman_ref_baseline_encodelog.out.nzdc
${BINDIRBASE}/${BENCHNAME}_bin: norm
${BINDIRNZDC}/${BENCHNAME}_bin: nzdc
${BENCHDIR}/run/foreman_ref_baseline_leakybucketparam.cfg.base ${BENCHDIR}/run/foreman_ref_baseline_encodelog.out.base: runnorm
${BENCHDIR}/run/foreman_ref_baseline_leakybucketparam.cfg.nzdc ${BENCHDIR}/run/foreman_ref_baseline_encodelog.out.nzdc: runnzdc