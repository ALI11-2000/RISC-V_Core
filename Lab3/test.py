import cocotb
from cocotb import triggers
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge
import random
import logging

#@cocotb.test()
async def Register_Test(dut):
    clk = Clock(dut.r1.clk,10,"ns")
    cocotb.fork(clk.start())
    await RisingEdge(dut.r1.clk)
    dut.r1.rst <= 1
    await RisingEdge(dut.r1.clk)
    dut.r1.rst <= 0
    await RisingEdge(dut.r1.clk)
    dut.r1.raddr1 <= 5
    dut.r1.reg_wr <= 1
    dut.r1.waddr <= 5
    dut.r1.wdata <= 10
    await RisingEdge(dut.r1.clk)
    dut.r1.reg_wr <= 0
    await RisingEdge(dut.r1.clk)

#@cocotb.test()
async def Instruction_Test(dut):
    dut.i1.Address <= 8
    await Timer(2,'ns')
    dut.i1.Address <= 4
    await Timer(2,'ns')
    dut.i1.Address <= 0
    await Timer(2,'ns')

@cocotb.test()
async def PC_Test(dut):
    clk = Clock(dut.p1.clk,10,"ns")
    cocotb.fork(clk.start())
    await RisingEdge(dut.p1.clk)
    dut.p1.ALU_out <= 10
    dut.p1.br_taken <= 0
    dut.p1.rst <= 1
    await RisingEdge(dut.p1.clk)
    dut.p1.rst <= 0
    await RisingEdge(dut.p1.clk)
    for i in range(2): await RisingEdge(dut.p1.clk)
    dut.p1.br_taken <= 1
    await RisingEdge(dut.p1.clk)
    dut.p1.br_taken <= 0
    for i in range(2): await RisingEdge(dut.p1.clk)