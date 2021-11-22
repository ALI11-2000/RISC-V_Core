import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge
import logging
from cocotb.wavedrom import trace 
import wavedrom


@cocotb.test()
async def phase1_Test(dut):
    """
    Testing for the First Phase of Project
    Testing the following instrucrtions
    addi x10,x0,10
    addi x11,x0,12
    addi x12,x0,15
    addi x13,x0,20
    addi x14,x0,24
    add x15,x10,x13
    add x16,x13,x15
    sw x10,0(x0)
    nop
    nop
    nop
    nop
    nop
    lw x17,0(x0)
    add x18,x0,x17
    """
    instruction = [
        "addi x10,x0,10",
        "addi x11,x0,12",
        "addi x12,x0,15",
        "addi x13,x0,20",
        "addi x14,x0,24",
        "add x15,x10,x13",
        "add x16,x13,x15",
        "sw x10,0(x0)",
        "lw x17,0(x0)",
        "add x18,x0,x17"
    ]
    clk = Clock(dut.clk,10,"ns")
    cocotb.fork(clk.start())
    with trace(dut.PC, dut.rf.register_file[10], dut.rf.register_file[11], dut.rf.register_file[12],\
         dut.rf.register_file[13], dut.rf.register_file[14], dut.rf.register_file[15],  dut.rf.register_file[16],\
         dut.rf.register_file[17], dut.rf.register_file[18], clk=dut.clk) as waves:
        await RisingEdge(dut.clk)
        dut.rst.value = 1
        await RisingEdge(dut.clk)
        dut.rst.value = 0
        for i in range(5): await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[10]) != 10): dut._log.error("Error in the first phase of pipeline {}".format(instruction[0]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[11]) != 12): dut._log.error("Error in the first phase of pipeline {}".format(instruction[1]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[12]) != 15): dut._log.error("Error in the first phase of pipeline {}".format(instruction[2]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[13]) != 20): dut._log.error("Error in the first phase of pipeline {}".format(instruction[3]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[14]) != 24): dut._log.error("Error in the first phase of pipeline {}".format(instruction[4]))
        ## Following check are for the phase 2 of Pipeline
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[15]) != 30): dut._log.error("Error in the 2nd phase of pipeline for data hazards {}".format(instruction[5]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[16]) != 54): dut._log.error("Error in the 2nd phase of pipeline for data hazards {}".format(instruction[6]))
        ## Following Instructions are for lw hazard
        for i in range(7): await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[17]) != 10): dut._log.error("Error in the 2nd phase of pipeline for data hazards {}".format(instruction[8]))
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[18]) != 10): dut._log.error("Error in the 2nd phase of pipeline for data hazards {}".format(instruction[9]))
        await RisingEdge(dut.clk)
        j = waves.dumpj()
        file  = open("dump.json",'w')
        file.write(j)
        file.close()
        svg = wavedrom.render(j)
        svg.saveas("out.svg")

