BENCHDIR := $(shell dirname -- "$(abspath "$(realpath "$MAKEFILE_LIST")")")
BENCHNAME = parsec.dedup
LLIB_BASE = -B/usr/lib/gcc/aarch64-linux-gnu/12/ -L/usr/lib/gcc/aarch64-linux-gnu/12/ -L${BENCHDIR}/../parsec.ssl/build_base/ -L${BENCHDIR}/../parsec.zlib/build_base/ -lm -lz
LLIB_NZDC = -B/usr/lib/gcc/aarch64-linux-gnu/12/ -L/usr/lib/gcc/aarch64-linux-gnu/12/ -L${BENCHDIR}/../parsec.ssl/build_nzdc/ -L${BENCHDIR}/../parsec.zlib/build_nzdc/ -lm -lz
EXTRACFLAGS = -I${BENCHDIR}/../../parsec_gc/pkgs/libs/ssl/inst/aarch64-linux.gcc/include -I${BENCHDIR}/../../parsec_gc/pkgs/libs/zlib/inst/aarch64-linux.gcc/include/ -fno-strict-aliasing -D_XOPEN_SOURCE=600 -DENABLE_GZIP_COMPRESSION -DENABLE_PTHREADS
RUNCMD = ./${BENCHNAME}_bin -c -p -v -t 1 -i media.dat -o output.dat.ddp > benchmark.out
REFOUTDIR = ${BENCHDIR}/../../parsec_gc/run_dir/pkgs/kernels/dedup/run
CMPCMD = diff output.dat.ddp ${REFOUTDIR}/output.dat.ddp && diff benchmark.out ${REFOUTDIR}/benchmark.out
LLVMDIRBASE = ${BENCHDIR}/../../LLVM3.7.1_build/
LLVMDIRNZDC = ${BENCHDIR}/../../nZDC_build/
BINDIRBASE = ${BENCHDIR}/build_base
BINDIRNZDC = ${BENCHDIR}/build_nzdc

.PHONY: all norm nzdc ssl_norm ssl_nzdc
all: norm nzdc
norm: ssl_norm ${BENCHDIR}/../parsec.zlib/build_base/libz.a
	BENCHNAME=${BENCHNAME} LLVMDIR=${LLVMDIRBASE} BINDIR=${BINDIRBASE} LLIB="${LLIB_BASE}" EXTRACFLAGS="${EXTRACFLAGS}" $(MAKE) -f Makefile.base $@
nzdc: ssl_nzdc ${BENCHDIR}/../parsec.zlib/build_nzdc/libz.a
	BENCHNAME=${BENCHNAME} LLVMDIR=${LLVMDIRNZDC} BINDIR=${BINDIRNZDC} LLIB="${LLIB_NZDC}" EXTRACFLAGS="${EXTRACFLAGS}" $(MAKE) -f Makefile.base $@
ssl_norm: 
	cd ${BENCHDIR}/../parsec.ssl/src && \
	$(MAKE) norm
ssl_nzdc: 
	cd ${BENCHDIR}/../parsec.ssl/src && \
	$(MAKE) nzdc
${BENCHDIR}/../parsec.zlib/build_base/libz.a:
	cd ${BENCHDIR}/../parsec.zlib/src && \
	$(MAKE) norm
${BENCHDIR}/../parsec.zlib/build_nzdc/libz.a:
	cd ${BENCHDIR}/../parsec.zlib/src && \
	$(MAKE) nzdc
.PHONY: clean cleannorm cleannzdc
clean: cleannorm cleannzdc
cleannorm:
	BENCHNAME=${BENCHNAME} LLVMDIR=${LLVMDIRBASE} BINDIR=${BINDIRBASE} $(MAKE) -f Makefile.base clean && \
	cd ${BENCHDIR}/../parsec.ssl/src && \
	$(MAKE) cleannorm && \
	cd ${BENCHDIR}/../parsec.zlib/src && \
	$(MAKE) cleannorm
cleannzdc:
	BENCHNAME=${BENCHNAME} LLVMDIR=${LLVMDIRNZDC} BINDIR=${BINDIRNZDC} $(MAKE) -f Makefile.base clean && \
	cd ${BENCHDIR}/../parsec.ssl/src && \
	$(MAKE) cleannzdc && \
	cd ${BENCHDIR}/../parsec.zlib/src && \
	$(MAKE) cleannzdc
.PHONY: run runnorm runnzdc
run: runnorm runnzdc comp
runnorm: ${BINDIRBASE}/${BENCHNAME}_bin
	cp ${BINDIRBASE}/${BENCHNAME}_bin ${BINDIRBASE}/../run/${BENCHNAME}_bin && \
	cd ${BINDIRBASE}/../run && \
	export LD_LIBRARY_PATH=${BENCHDIR}/../../LLVM3.7.1_build/lib:${LD_LIBRARY_PATH} && \
	time -a -o time_base ${RUNCMD} && \
	mv benchmark.out benchmark.out.base && \
	mv output.dat.ddp output.dat.ddp.base
	
runnzdc: ${BINDIRNZDC}/${BENCHNAME}_bin
	cp ${BINDIRNZDC}/${BENCHNAME}_bin ${BINDIRNZDC}/../run/${BENCHNAME}_bin && \
	cd ${BINDIRNZDC}/../run && \
	export LD_LIBRARY_PATH=${BENCHDIR}/../../LLVM3.7.1_build/lib:${LD_LIBRARY_PATH} && \
	time -a -o time_nzdc ${RUNCMD} && \
	mv benchmark.out benchmark.out.nzdc && \
	mv output.dat.ddp output.dat.ddp.nzdc

comp: ${BENCHDIR}/run/benchmark.out.base ${BENCHDIR}/run/benchmark.out.nzdc ${BENCHDIR}/run/output.dat.ddp.base ${BENCHDIR}/run/output.dat.ddp.nzdc
	diff ${BENCHDIR}/run/benchmark.out.base ${BENCHDIR}/run/benchmark.out.nzdc && \
	diff ${BENCHDIR}/run/output.dat.ddp.base ${BENCHDIR}/run/output.dat.ddp.nzdc
${BINDIRBASE}/${BENCHNAME}_bin: norm
${BINDIRNZDC}/${BENCHNAME}_bin: nzdc
${BENCHDIR}/run/benchmark.out.base ${BENCHDIR}/run/output.dat.ddp.base: runnorm
${BENCHDIR}/run/benchmark.out.nzdc ${BENCHDIR}/run/output.dat.ddp.nzdc: runnzdc