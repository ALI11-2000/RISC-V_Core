import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge
import logging
from cocotb.wavedrom import trace 
import wavedrom
from cocotb.binary import BinaryRepresentation, BinaryValue


@cocotb.test()
async def phase1_Test(dut):
    """
    Testing for the First Phase of Project
    Testing the following instrucrtions
    addi x10,x0,11
    addi x11,x0,14
    addi x12,x0,13
    addi x13,x0,19
    addi x14,x0,24
    or x19, x10, x11
    sll x20, x11, x12
    sub x21, x13, x14
    addi x10,x0,10
    addi x11,x0,12
    addi x12,x0,15
    addi x13,x0,20
    add x15,x10,x13
    add x16,x13,x15
    sw x10,12(x0)
    lw x17,0(x0)
    add x18,x0,x17
    """
    instruction = [
        "addi x10,x0,11",
        "addi x11,x0,14",
        "addi x12,x0,13",
        "addi x13,x0,19",
        "addi x14,x0,24",
        "or x19, x10, x11",
        "sll x20, x11, x12",
        "sub x21, x13, x14",
        "addi x10,x0,10",
        "addi x11,x0,12",
        "addi x12,x0,15",
        "addi x13,x0,20",
        "add x15,x10,x13",
        "add x16,x13,x15",
        "lw x17,0(x0)",
        "add x18,x0,x17"
    ]
    clk = Clock(dut.clk,10,"ns")
    cocotb.fork(clk.start())
    with trace(dut.PC, dut.rf.register_file[10], dut.rf.register_file[11], dut.rf.register_file[12],\
         dut.rf.register_file[13], dut.rf.register_file[14], dut.rf.register_file[15],  dut.rf.register_file[16],\
         dut.rf.register_file[17], dut.rf.register_file[18], dut.rf.register_file[19],  dut.rf.register_file[20],\
         dut.rf.register_file[21], dut.rf.register_file[22], dut.rf.register_file[23], clk=dut.clk) as waves:
        await RisingEdge(dut.clk)
        print(BinaryValue(-1,n_bits=32,bigEndian=False,binaryRepresentation=BinaryRepresentation.TWOS_COMPLEMENT))
        dut.rst.value = 1
        await RisingEdge(dut.clk)
        dut.rst.value = 0
        for i in range(5): await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[10]) != 11): dut._log.error("Error in the first phase of pipeline {}".format(instruction[0]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[11]) != 14): dut._log.error("Error in the first phase of pipeline {}".format(instruction[1]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[12]) != 13): dut._log.error("Error in the first phase of pipeline {}".format(instruction[2]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[13]) != 19): dut._log.error("Error in the first phase of pipeline {}".format(instruction[3]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[14]) != 24): dut._log.error("Error in the first phase of pipeline {}".format(instruction[4]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[19]) != 15): dut._log.error("Error in the first phase of pipeline {}".format(instruction[5]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[20]) != 114688): dut._log.error("Error in the first phase of pipeline {}".format(instruction[6]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[21]) != 4294967291): dut._log.error("Error in the first phase of pipeline {}".format(instruction[7]))
        ## Following check are for the phase 2 of Pipeline
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[10]) != 10): dut._log.error("Error in the first phase of pipeline {}".format(instruction[8]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[11]) != 12): dut._log.error("Error in the first phase of pipeline {}".format(instruction[9]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[12]) != 15): dut._log.error("Error in the first phase of pipeline {}".format(instruction[10]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[13]) != 20): dut._log.error("Error in the first phase of pipeline {}".format(instruction[11]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[15]) != 30): dut._log.error("Error in the 2nd phase of pipeline for data hazards {}".format(instruction[12]))
        await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[16]) != 50): dut._log.error("Error in the 2nd phase of pipeline for data hazards {}".format(instruction[13]))
        ## Following Instructions are for lw hazard
        while(int(dut.PC_W) != 16*4): await RisingEdge(dut.clk)
        if (int(dut.rf.register_file[17]) != 10): dut._log.error("Error in the 2nd phase of pipeline for data hazards {}".format(instruction[14]))
        while(int(dut.PC_W) != 17*4): await RisingEdge(dut.clk)
        assert (int(dut.rf.register_file[18]) == 10), dut._log.error("Error in the 2nd phase of pipeline for data hazards {} value is {}".format(instruction[15],int(dut.rf.register_file[18])))
        await RisingEdge(dut.clk)
        for i in range(17): await RisingEdge(dut.clk)
        j = waves.dumpj()
        file  = open("dump.json",'w')
        file.write(j)
        file.close()
        svg = wavedrom.render(j)
        svg.saveas("out.svg")
        x = (dut.rf.register_file[18].value)
        print(x.real)

