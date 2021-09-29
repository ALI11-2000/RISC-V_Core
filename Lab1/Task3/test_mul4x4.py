import cocotb
from cocotb import triggers
from cocotb.triggers import Timer
import random
import logging

@cocotb.test()
async def mu4x4_test(dut):
    dut.A <= 15
    dut.B <= 15
    await triggers.Timer(2,'ns')

    dut.A <= 2
    dut.B <= 3
    await triggers.Timer(2,'ns')

    dut.A <= 8
    dut.B <= 9
    await triggers.Timer(2,'ns')