`include "../srcs/Register_File.sv"
`include "../srcs/Program_Counter.sv"
`include "../srcs/Immediate_Generator.sv"
`include "../srcs/ALU.sv"
`include "../srcs/Branch_Condition.sv"
`include "../srcs/Data_Memory.sv"
`include "../srcs/Controller.sv"
`include "../srcs/Decode.sv"
`include "../srcs/Execute.sv"
`include "../srcs/Memory.sv"
`include "../srcs/Writeback.sv"
`include "../srcs/mux31.sv"
`include "../srcs/hazard_unit.sv"
`include "../srcs/csr.sv"
`include "../srcs/timer.sv"
`include "../srcs/LSU.sv"
`timescale 1ns/1ns

module top_core(
    input [31:0] Instruction,
    input [31:0] num1, 
    input [31:0] num2, 
    output [31:0] result,
    output [31:0] PC,
    input clk, rst
);
    
    wire[31:0] rdata1, rdata2, rdata_out, wdata_out, addr;
    wire [31:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31;
    wire [4:0] raddr1, raddr2, waddr;
    reg [31:0] wdata;
    wire [31:0] ALU_out, ALU_out_M, ALU_out_W, Immediate_Value, rdata;
    reg [31:0] A, B;
    wire [3:0] alu_op, alu_opE;
    wire [2:0] br_type, br_typeE, rd_en, wr_en, rd_enE, wr_enE, rd_enM, wr_enM;
    wire [1:0] wb_sel, wb_selE, wb_selM, wb_selW, For_A, For_B;
    wire sel_A, sel_B;
    reg csr_flag1;
    wire [31:0] PC_D, PC_M, PC_W, Instruction_D, rdata_csr, CSR_RD;
    wire [31:0] PC_E, rs1_E, rs2_E, Immediate_Value_E, mux_out_A, mux_out_B;
    wire [31:0] Instruction_E, WD_M, Instruction_M, RD_W, Instruction_W, epc_evec;

    Decode pipeline_decode(.PC_D(PC_D), .Instruction_D(Instruction_D), .rst(rst),
    .PC(PC), .Instruction(Instruction), .clk(clk), .StallD(StallD), .FlushD(FlushD || FlushD1));

    Execute pipeline_execute(
    .PC_E(PC_E), .rs1_E(rs1_E), .rs2_E(rs2_E),
    .Immediate_Value_E(Immediate_Value_E), .Instruction_E(Instruction_E),
    .alu_opE(alu_opE), .reg_wrE(reg_wrE), .sel_AE(sel_AE), .sel_BE(sel_BE),
    .wr_enE(wr_enE), .rd_enE(rd_enE), .wb_selE(wb_selE), .br_typeE(br_typeE),
    .PC_D(PC_D), .rdata1(rdata1), .rdata2(rdata2),
    .Immediate_Value(Immediate_Value), .Instruction_D(Instruction_D),
    .alu_op(alu_op), .reg_wr(reg_wr), .sel_A(sel_A), .sel_B(sel_B),
    .wr_en(wr_en), .rd_en(rd_en), .wb_sel(wb_sel), .br_type(br_type), .clk(clk),
    .FlushE(FlushE || FlushE1), .rst(rst));

    Memory pipeline_memory(.PC_M(PC_M), .ALU_out_M(ALU_out_M), .WD_M(WD_M),
    .Instruction_M(Instruction_M), .reg_wrM(reg_wrM), .wr_enM(wr_enM),
    .rd_enM(rd_enM), .wb_selM(wb_selM),
    .PC_E(PC_E), .ALU_out_E(ALU_out), .WD_E(mux_out_B),
    .Instruction_E(Instruction_E), .reg_wrE(reg_wrE), .wr_enE(wr_enE),
    .rd_enE(rd_enE), .wb_selE(wb_selE), .clk(clk), .rst(rst)
    );

    Writeback pipeline_writeback( .PC_W(PC_W), .ALU_out_W(ALU_out_W), .RD_W(RD_W), .Instruction_W(Instruction_W),
    .reg_wrW(reg_wrW), .wb_selW(wb_selW),
    .PC_M(PC_M), .ALU_out_M(ALU_out_M), .RD_M(rdata_out), .Instruction_M(Instruction_M),
    .reg_wrM(reg_wrM), .wb_selM(wb_selM), .clk(clk), .rst(rst),
    .rdata(rdata_csr), .CSR_RD(CSR_RD), .FlushW(FlushW)
    );

    Register_File rf(.rdata1(rdata1), .rdata2(rdata2), 
    .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8), .x9(x9), .x10(x10), .x11(x11), .x12(x12), .x13(x13), .x14(x14),
    .x15(x15), .x16(x16), .x17(x17), .x18(x18), .x19(x19), .x20(x20), .x21(x21), .x22(x22), .x23(x23), .x24(x24), .x25(x25), .x26(x26), .x27(x27),
    .x28(x28), .x29(x29), .x30(x30), .x31(x31),
    .raddr1(Instruction_D[19:15]), .raddr2(Instruction_D[24:20]),
    .waddr(Instruction_W[11:7]), .wdata(wdata), .clk(clk), .rst(rst), .reg_wr(reg_wrW));

    Program_Counter pc(.ALU_out(ALU_out), .br_taken(br_taken), .clk(clk), .rst(rst), .PC(PC), .hard_write(hard_write),
                       .StallF(StallF), .csr(csr_flag), .epc_evec(epc_evec));


    Immediate_Generator ig(.Immediate_Value(Immediate_Value), .Instruction(Instruction_D), .unsign(unsign));

    always @(*) begin
        A <= sel_AE ? PC_E : mux_out_A;
        B <= sel_BE ? Immediate_Value_E : mux_out_B;
    end
    
    mux31 m1(.out(mux_out_A), .b(ALU_out_M), .a(rs1_E), .c(wdata), .sel(For_A));

    mux31 m2(.out(mux_out_B), .b(ALU_out_M), .a(rs2_E), .c(wdata), .sel(For_B));

    ALU al(.ALU_out(ALU_out),.A(A), .B(B),.alu_op(alu_opE));

    Branch_Condition bcond(.br_taken(br_taken), .A(mux_out_A), .B(mux_out_B), .br_type(br_typeE));

    hazard_unit hazard(.For_A(For_A), .For_B(For_B), .reg_wrM(reg_wrM), .reg_wrW(reg_wrW),
    .Instruction_E(Instruction_E), .Instruction_M(Instruction_M), .Instruction_W(Instruction_W),
    .Instruction_D(Instruction_D), .wb_selE(wb_selE), .StallF(StallF), .StallD(StallD), .FlushE(FlushE),
    .FlushD(FlushD), .br_taken(br_taken));

    LSU  ls(.rd_en(rd_enM), .wr_en(wr_enM), .address(ALU_out_M), .wdata(WD_M), 
    .rdata_in(rdata),
    .rdata_out(rdata_out), .wdata_out(wdata_out), .address_out(addr));

    Data_Memory dmem(.num1(num1), .num2(num2), .result(result), .hard_write(hard_write),
                     .rdata(rdata), .wdata(wdata_out), .addr(addr),
                     .wr_en(wr_enM), .rd_en(rd_enM), .clk(clk), .rst(rst));

    csr csr1(.rdata(rdata_csr), .epc_evec(epc_evec), .csr_flag(csr_flag),
    .addr({{20'b0},{Instruction_M[31:20]}}), .operand(ALU_out_M), .Instruction_M(Instruction_M), .PC_M(PC_M),
    .clk(clk), .rst(rst), .interrupt(interrupt), .FlushD1(FlushD1), .FlushE1(FlushE1), .FlushW(FlushW)
    );

    timer interrupt1(.interrupt(interrupt),.clk(clk), .rst(rst));

    always_comb begin 
        case (wb_selW)
            0 : wdata =  PC_W + 4;
            1 : wdata = ALU_out_W;
            2 : wdata = RD_W;
            3 : wdata = CSR_RD;
        endcase
    end 

    Controller cont(.Instruction(Instruction_D), .alu_op(alu_op), .reg_wr(reg_wr), .sel_A(sel_A), .sel_B(sel_B),
    .wr_en(wr_en), .rd_en(rd_en), .br_type(br_type), .wb_sel(wb_sel), .unsign(unsign));  

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(2,top);
    end
    
endmodule