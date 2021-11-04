TOPLEVEL_LANG ?= verilog
PWD = $(shell pwd)
export PYTHONPATH := $(PWD):$(PYTHONPATH)
VERILOG_SOURCES = $(PWD)/../srcs/top.sv
TOPLEVEL := top
MODULE := test
include $(shell cocotb-config --makefiles)/Makefile.sim



.PHONY: clean
clean::
	rm -rf *.vcd *.xml __pycache__ sim_build
