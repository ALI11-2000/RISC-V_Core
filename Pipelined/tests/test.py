import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge
import logging
from cocotb.binary import BinaryRepresentation, BinaryValue

@cocotb.test()
async def gcd_Test(dut):
    clk = Clock(dut.clk,10,"ns")
    cocotb.fork(clk.start())
    await RisingEdge(dut.clk)
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    for j in range(100):await RisingEdge(dut.clk)