import cocotb
from cocotb import triggers
from cocotb.triggers import Timer
import random
import logging

@cocotb.test()
async def half_adder_test(dut):
    for i in range(4):
        for j in range(4):
            for k in range(2):
                dut.A.value = i
                dut.B.value = j
                dut.C_in.value = k
                await triggers.Timer(2,"ns")
                dut._log.info("A = %d, B = %d, C_in = %d, C_out = %d, S = %d",i,j,k,int(dut.C_out.value),int(dut.S.value))