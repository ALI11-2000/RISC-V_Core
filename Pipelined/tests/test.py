import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge
import logging
from cocotb.wavedrom import trace 
import wavedrom
from cocotb.binary import BinaryRepresentation, BinaryValue

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
    for j in range(50):await RisingEdge(dut.clk)