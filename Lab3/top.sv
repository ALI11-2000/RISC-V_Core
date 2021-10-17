`include "Register_File.sv"
`include "Instruction_Memory.sv"
`include "Program_Counter.sv"
`include "Immediate_Generator.sv"
`timescale 1ns/1ns

module top(
    input clk, rst
);
    
    wire[31:0] rdata1, rdata2;
    wire [31:0]x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31;
    input [4:0] raddr1, raddr2, waddr;
    input [31:0] wdata;

    Register_File rf(.rdata1(rdata1), .rdata2(rdata2), 
    .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8), .x9(x9), .x10(x10), .x11(x11), .x12(x12), .x13(x13), .x14(x14),
    .x15(x15), .x16(x16), .x17(x17), .x18(x18), .x19(x19), .x20(x20), .x21(x21), .x22(x22), .x23(x23), .x24(x24), .x25(x25), .x26(x26), .x27(x27),
    .x28(x28), .x29(x29), .x30(x30), .x31(x31),
    .raddr1(raddr1), .raddr2(raddr2), .waddr(waddr), .wdata(wdata), .clk(clk), .rst(rst), .reg_wr(reg_wr));

    wire [31:0] Instruction, PC, ALU_out, Immediate_Value;

    Instruction_Memory im(.Instruction(Instruction), .Address(PC));

    Program_Counter pc(.ALU_out(ALU_out), .br_taken(br_taken), .clk(clk), .rst(rst), .PC(PC));

    Immediate_Generator ig(.Immediate_Value(Immediate_Value), .Instruction(Instruction));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
    
endmodule