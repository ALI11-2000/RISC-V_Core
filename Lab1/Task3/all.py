import cocotb
from cocotb import triggers
from cocotb.triggers import Timer
import random
import logging

@cocotb.test()
async def mu4x4_test(dut):
    file = open("result.txt","w")
    for i in range(1,16):
        for j in range(1,16):
            dut.A <= i
            dut.B <= j
            await triggers.Timer(2,'ns')
            # dut._log.info("%d x %d = %d",int(dut.A),int(dut.B),int(dut.R))
            file.write("{} x {} = {} \n".format(int(dut.A),int(dut.B),int(dut.R)))
            assert int(dut.R) == i*j,"Assertion error"
        file.write("\n\n")