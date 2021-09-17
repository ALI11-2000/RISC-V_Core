import cocotb
from cocotb import triggers
from cocotb.triggers import Timer
import random
import logging

@cocotb.test()
async def half_adder_test(dut):
    for i in range(4):
        for j in range(4):
            dut.A.value = i
            dut.B.value = j
            await triggers.Timer(2,"ns")