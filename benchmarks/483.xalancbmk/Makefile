BENCHDIR := $(shell dirname -- "$(abspath "$(realpath "$MAKEFILE_LIST")")")
BENCHNAME = 483.xalancbmk
LLIB = -stdlib=libc++ -B/usr/lib/gcc/aarch64-linux-gnu/12/ -L/usr/lib/gcc/aarch64-linux-gnu/12/ -lc++abi
EXTRACFLAGS = -DAPP_NO_THREADS -DXALAN_INMEM_MSG_LOADER -I. -Ixercesc -Ixercesc/dom -Ixercesc/dom/impl -Ixercesc/sax -Ixercesc/util/MsgLoaders/InMemory -Ixercesc/util/Transcoders/Iconv -Ixalanc/include -DPROJ_XMLPARSER -DPROJ_XMLUTIL -DPROJ_PARSERS -DPROJ_SAX4C -DPROJ_SAX2 -DPROJ_DOM -DPROJ_VALIDATORS -DXML_USE_NATIVE_TRANSCODER -DXML_USE_INMEM_MESSAGELOADER -DSPEC_CPU_LINUX -stdlib=libc++
RUNCMD = ./${BENCHNAME}_bin -v t5.xml xalanc.xsl > ref.out
REFOUTDIR = ${BENCHDIR}/../../spec06/benchspec/CPU2006/${BENCHNAME}/data/ref/output/
CMPCMD = diff ref.out ${REFOUTDIR}/ref.out
LLVMDIRBASE = ${BENCHDIR}/../../LLVM3.7.1_build/
LLVMDIRNZDC = ${BENCHDIR}/../../nZDC_build/
BINDIRBASE = ${BENCHDIR}/build_base
BINDIRNZDC = ${BENCHDIR}/build_nzdc

# cstdlib not found even in base

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
	/usr/bin/time -o time_base ${RUNCMD} && \
	${CMPCMD}
	
runnzdc: ${BINDIRNZDC}/${BENCHNAME}_bin
	cp ${BINDIRNZDC}/${BENCHNAME}_bin ${BINDIRNZDC}/../run/${BENCHNAME}_bin && \
	cd ${BINDIRNZDC}/../run && \
	export LD_LIBRARY_PATH=${BENCHDIR}/../../LLVM3.7.1_build/lib:${LD_LIBRARY_PATH} && \
	/usr/bin/time -o time_nzdc ${RUNCMD} && \
	${CMPCMD}
${BINDIRBASE}/${BENCHNAME}_bin: norm
${BINDIRNZDC}/${BENCHNAME}_bin: nzdc