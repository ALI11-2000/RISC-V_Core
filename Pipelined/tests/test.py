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
    dut.rf.rst.value = 1
    await RisingEdge(dut.rf.clk)
    dut.rf.rst.value = 0
    await RisingEdge(dut.rf.clk)
    dut.rf.raddrf.value = 5
    dut.rf.reg_wr.value = 1
    dut.rf.waddr.value = 5
    dut.rf.wdata.value = 10
    await RisingEdge(dut.rf.clk)
    dut.rf.reg_wr.value = 0
    await RisingEdge(dut.rf.clk)

#@cocotb.test()
async def Instruction_Test(dut):
    dut.im.Address.value = 8
    await Timer(2,'ns')
    dut.im.Address.value = 4
    await Timer(2,'ns')
    dut.im.Address.value = 0
    await Timer(2,'ns')

#@cocotb.test()
async def PC_Test(dut):
    clk = Clock(dut.pc.clk,10,"ns")
    cocotb.fork(clk.start())
    await RisingEdge(dut.pc.clk)
    dut.pc.ALU_out.value = 10
    dut.pc.br_taken.value = 0
    dut.pc.rst.value = 1
    await RisingEdge(dut.pc.clk)
    dut.pc.rst.value = 0
    await RisingEdge(dut.pc.clk)
    for i in range(2): await RisingEdge(dut.pc.clk)
    dut.pc.br_taken.value = 1
    await RisingEdge(dut.pc.clk)
    dut.pc.br_taken.value = 0
    for i in range(2): await RisingEdge(dut.pc.clk)

#@cocotb.test()
async def Imm_Gen(dut):
    # addi x10,x11,21
    dut.ig.Instruction.value = 22381843
    await Timer(2,'ns')
    # sw x10,4(x0)
    dut.ig.Instruction.value = 10494499
    await Timer(2,'ns')
    # beq x0,x0,-8
    dut.ig.Instruction.value = 4261416163
    await Timer(2,'ns')
    # jal x0,-12
    dut.ig.Instruction.value = 4284477551
    await Timer(2,'ns')
    # lui x10,1234 = 5054464
    dut.ig.Instruction.value = 5055799
    await Timer(2,'ns')

#@cocotb.test()
async def alu(dut):
    dut.al.A.value = 10
    dut.al.B.value = 10
    dut.al.alu_op.value = 3
    await Timer(2,'ns')
    dut.al.alu_op.value = 0
    await Timer(2,'ns')

#@cocotb.test()
async def cond(dut):
    dut.bcond.A.value = 10
    dut.bcond.B.value = 10
    dut.bcond.br_type.value = 0
    await Timer(2,'ns')
    dut.bcond.br_type.value = 1
    await Timer(2,'ns')
    dut.bcond.br_type.value = 6
    await Timer(2,'ns')

#@cocotb.test()
async def Data_Test(dut):
    clk = Clock(dut.dmem.clk,10,"ns")
    cocotb.fork(clk.start())
    await RisingEdge(dut.dmem.clk)
    dut.dmem.rst.value = 1
    await RisingEdge(dut.dmem.clk)
    dut.dmem.rst.value = 0
    await RisingEdge(dut.dmem.clk)
    dut.dmem.addr.value = 10
    dut.dmem.wdata.value = 100
    dut.dmem.wr_en.value = 1
    await RisingEdge(dut.rf.clk)
    dut.dmem.wr_en.value = 0
    await RisingEdge(dut.rf.clk)
    dut.dmem.rd_en.value = 1
    await RisingEdge(dut.rf.clk)
    dut.dmem.rd_en.value = 0
    await RisingEdge(dut.rf.clk)

@cocotb.test()
async def gcd_Test(dut):
    clk = Clock(dut.clk,10,"ns")
    cocotb.fork(clk.start())
    await RisingEdge(dut.clk)
    dut.rst.value = 1
    dut.num1.value = 2
    dut.num2.value = 4
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.hard_write.value = 1
    await RisingEdge(dut.clk)
    dut.hard_write.value = 0
    for i in range(2): await RisingEdge(dut.clk)
    while(int(dut.PC_W) != 40): await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst.value = 1
    dut.num1.value = 3
    dut.num2.value = 9
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.hard_write.value = 1
    await RisingEdge(dut.clk)
    dut.hard_write.value = 0
    for i in range(2): await RisingEdge(dut.clk)
    while(int(dut.PC_W) != 40): await RisingEdge(dut.clk)