SPEC_BENCHS = 401.bzip2 429.mcf 456.hmmer 458.sjeng 462.libquantum 473.astar 400.perlbench 464.h264ref 445.gobmk
PARSEC_BENCHS = parsec.blackscholes parsec.dedup parsec.fluidanimate parsec.freqmine parsec.streamcluster parsec.swaptions
BENCHMARKS = $(SPEC_BENCHS) $(PARSEC_BENCHS) 403.gcc 471.omnetpp 483.xalancbmk

RUNSPEC		:= $(foreach bench,$(SPEC_BENCHS),run_$(bench))
RUNPARSEC	:= $(foreach bench,$(PARSEC_BENCHS),run_$(bench))
RUNBENCHS	:= $(foreach bench,$(BENCHMARKS),run_$(bench))

.PHONY: run run_spec run_parsec $(RUNBENCHS)
run_spec: $(RUNSPEC)
	grep us */run/time*
run_parsec: $(RUNPARSEC)
	grep us */run/time*
run: run_spec run_parsec
$(RUNBENCHS):
	cd $(subst run_,,$@)/src && \
	$(MAKE) clean && \
	$(MAKE) all && \
	$(MAKE) run

