`include "Register_File.sv"
`include "Instruction_Memory.sv"
`include "Program_Counter.sv"
`include "Immediate_Generator.sv"
`include "ALU.sv"
`include "Branch_Condition.sv"
`include "Data_Memory.sv"
`include "Controller.sv"
`include "Decode.sv"
`include "Execute.sv"
`timescale 1ns/1ns

module top(
    input clk, rst
);
    
    wire[31:0] rdata1, rdata2, num1, num2, result;
    wire [31:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31;
    wire [4:0] raddr1, raddr2, waddr;
    reg [31:0] wdata;
    wire [31:0] Instruction, PC, ALU_out, Immediate_Value, rdata;
    reg [31:0] A, B;
    wire [3:0] alu_op, alu_opE;
    wire [2:0] br_type, br_typeE;
    wire [1:0] wb_sel;
    wire sel_A, sel_B;
    wire [31:0] PC_D, Instruction_D;
    wire [31:0] PC_E, rs1_E, rs2_E, Immediate_Value_E;
    wire [31:0] Instruction_E;

    Decode pipeline_decode(.PC_D(PC_D), .Instruction_D(Instruction_D),
    .PC(PC), .Instruction(Instruction), .clk(clk));

    Execute pipeline_execute(
    .PC_E(PC_E), .rs1_E(rs1_E), .rs2_E(rs2_E),
    .Immediate_Value_E(Immediate_Value_E), .Instruction_E(Instruction_E),
    .alu_opE(alu_opE), .reg_wrE(reg_wrE), .sel_AE(sel_AE), .sel_BE(sel_BE),
    .wr_enE(wr_enE), .rd_enE(rd_enE), .wb_selE(wb_selE), .br_typeE(br_typeE),
    .PC_D(PC_D), .rdata1(rdata1), .rdata2(rdata2),
    .Immediate_Value(Immediate_Value), .Instruction_D(Instruction_D),
    .alu_op(alu_op), .reg_wr(reg_wr), .sel_A(sel_A), .sel_B(sel_B),
    .wr_en(wr_en), .rd_en(rd_en), .wb_sel(wb_sel), .br_type(br_type), .clk(clk)
    );

    Register_File rf(.rdata1(rdata1), .rdata2(rdata2), 
    .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8), .x9(x9), .x10(x10), .x11(x11), .x12(x12), .x13(x13), .x14(x14),
    .x15(x15), .x16(x16), .x17(x17), .x18(x18), .x19(x19), .x20(x20), .x21(x21), .x22(x22), .x23(x23), .x24(x24), .x25(x25), .x26(x26), .x27(x27),
    .x28(x28), .x29(x29), .x30(x30), .x31(x31),
    .raddr1(Instruction_D[19:15]), .raddr2(Instruction_D[24:20]),
    .waddr(Instruction_D[11:7]), .wdata(wdata), .clk(clk), .rst(rst), .reg_wr(reg_wr));

    Instruction_Memory im(.Instruction(Instruction), .Address(PC));

    Program_Counter pc(.ALU_out(ALU_out), .br_taken(br_taken), .clk(clk), .rst(rst), .PC(PC), .hard_write(hard_write));

    Immediate_Generator ig(.Immediate_Value(Immediate_Value), .Instruction(Instruction_D), .unsign(unsign));

    always @(*) begin
        A <= sel_AE ? PC_E : rs1_E;
        B <= sel_BE ? Immediate_Value_E : rs2_E;
    end
    

    ALU al(.ALU_out(ALU_out),.A(A), .B(B),.alu_op(alu_opE));

    Branch_Condition bcond(.br_taken(br_taken), .A(rs1_E), .B(rs2_E), .br_type(br_typeE));

    Data_Memory dmem(.num1(num1), .num2(num2), .result(result), .hard_write(hard_write),
                     .rdata(rdata), .wdata(rdata2), .addr(ALU_out),
                     .wr_en(wr_en), .rd_en(rd_en), .clk(clk), .rst(rst));


    always_comb begin 
        case (wb_sel)
            0 : wdata <=  PC + 4;
            1 : wdata <= ALU_out;
            2 : wdata <= rdata;
        endcase
    end 

    Controller cont(.Instruction(Instruction_D), .alu_op(alu_op), .reg_wr(reg_wr), .sel_A(sel_A), .sel_B(sel_B),
    .wr_en(wr_en), .rd_en(rd_en), .br_type(br_type), .wb_sel(wb_sel), .unsign(unsign));  

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
    
endmodule