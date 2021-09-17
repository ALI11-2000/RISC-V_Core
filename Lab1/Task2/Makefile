TOPLEVEL_LANG ?= verilog
PWD = $(shell pwd)
export PYTHONPATH := $(PWD):$(PYTHONPATH)
VERILOG_SOURCES = full_adder.sv
TOPLEVEL := full_adder
MODULE := test_full_adder
include $(shell cocotb-config --makefiles)/Makefile.sim



.PHONY: clean
clean::
	rm -rf *.vcd *.xml __pycache__ sim_build
