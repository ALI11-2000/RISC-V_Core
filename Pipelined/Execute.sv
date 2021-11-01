module Execute (
    output reg [31:0] PC_E, rs1_E, rs2_E,
    Immediate_Value_E, Instruction_E,
    output reg [3:0] alu_opE, output reg reg_wrE, sel_AE, sel_BE,
    wr_enE, rd_enE, wb_selE, output reg [2:0] br_typeE,
    input [31:0] PC_D, rdata1, rdata2,
    Immediate_Value, Instruction_D,
    input [3:0] alu_op, input reg_wr, sel_A, sel_B,
    wr_en, rd_en, wb_sel, clk, input[2:0] br_type
);
    always @(posedge clk ) begin
        PC_E <= PC_D;
        rs1_E <= rdata1;
        rs2_E <= rdata2;
        Immediate_Value_E <= Immediate_Value;
        Instruction_E <= Instruction_D;
        {alu_opE, reg_wrE, sel_AE, sel_BE, wr_enE, rd_enE, wb_selE, br_typeE} <= {alu_op, reg_wr, sel_A, sel_B,
        wr_en, rd_en, wb_sel, br_type};
    end
    
endmodule