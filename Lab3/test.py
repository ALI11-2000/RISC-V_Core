import cocotb
from cocotb import triggers
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge
import random
import logging

#@cocotb.test()
async def Register_Test(dut):
    clk = Clock(dut.rf.clk,10,"ns")
    cocotb.fork(clk.start())
    await RisingEdge(dut.rf.clk)
    dut.rf.rst <= 1
    await RisingEdge(dut.rf.clk)
    dut.rf.rst <= 0
    await RisingEdge(dut.rf.clk)
    dut.rf.raddrf <= 5
    dut.rf.reg_wr <= 1
    dut.rf.waddr <= 5
    dut.rf.wdata <= 10
    await RisingEdge(dut.rf.clk)
    dut.rf.reg_wr <= 0
    await RisingEdge(dut.rf.clk)

#@cocotb.test()
async def Instruction_Test(dut):
    dut.im.Address <= 8
    await Timer(2,'ns')
    dut.im.Address <= 4
    await Timer(2,'ns')
    dut.im.Address <= 0
    await Timer(2,'ns')

#@cocotb.test()
async def PC_Test(dut):
    clk = Clock(dut.pc.clk,10,"ns")
    cocotb.fork(clk.start())
    await RisingEdge(dut.pc.clk)
    dut.pc.ALU_out <= 10
    dut.pc.br_taken <= 0
    dut.pc.rst <= 1
    await RisingEdge(dut.pc.clk)
    dut.pc.rst <= 0
    await RisingEdge(dut.pc.clk)
    for i in range(2): await RisingEdge(dut.pc.clk)
    dut.pc.br_taken <= 1
    await RisingEdge(dut.pc.clk)
    dut.pc.br_taken <= 0
    for i in range(2): await RisingEdge(dut.pc.clk)

@cocotb.test()
async def Imm_Gen(dut):
    # addi x10,x11,21
    dut.ig.Instruction <= 22381843
    await Timer(2,'ns')
    # sw x10,4(x0)
    dut.ig.Instruction <= 10494499
    await Timer(2,'ns')
    # beq x0,x0,-8
    dut.ig.Instruction <= 4261416163
    await Timer(2,'ns')
    # jal x0,-12
    dut.ig.Instruction <= 4284477551
    await Timer(2,'ns')
    # lui x10,1234 = 5054464
    dut.ig.Instruction <= 5055799
    await Timer(2,'ns')