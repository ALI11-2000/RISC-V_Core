module Execute (
    output reg [31:0] PC_E, rs1_E, rs2_E,
    Immediate_Value_E, Instruction_E,
    output reg [3:0] alu_opE, output reg reg_wrE, sel_AE, sel_BE,
    wr_enE, rd_enE, output reg [1:0] wb_selE, output reg [2:0] br_typeE,
    input [31:0] PC_D, rdata1, rdata2,
    Immediate_Value, Instruction_D,
    input [3:0] alu_op, input reg_wr, sel_A, sel_B, FlushE, rst,
    wr_en, rd_en, input [1:0] wb_sel, input clk, input[2:0] br_type
);
    always @(posedge clk ) begin
        if(FlushE || rst) begin
            PC_E <= 0;
            rs1_E <= 0;
            rs2_E <= 0;
            Immediate_Value_E <= 0;
            Instruction_E <= 0;
            {alu_opE, sel_AE, sel_BE, wr_enE, rd_enE, wb_selE} <= 11'b0;
            br_typeE <= 3'b111;
            reg_wrE <= 0;
        end else begin
        PC_E <= PC_D;
        rs1_E <= rdata1;
        rs2_E <= rdata2;
        Immediate_Value_E <= Immediate_Value;
        Instruction_E <= Instruction_D;
        {alu_opE, sel_AE, sel_BE, wr_enE, rd_enE, wb_selE, br_typeE} <= {alu_op, sel_A, sel_B,
        wr_en, rd_en, wb_sel, br_type};
        reg_wrE <= reg_wr;
        end
    end
 
endmodule