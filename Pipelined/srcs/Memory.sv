module Memory (
    output reg [31:0] PC_M, ALU_out_M, WD_M,
    Instruction_M, output reg reg_wrM, wr_enM,
    rd_enM, output reg [1:0] wb_selM,
    input [31:0] PC_E, ALU_out_E, WD_E,
    Instruction_E, input reg_wrE, wr_enE,
    rd_enE, input [1:0] wb_selE, input clk
);

    always @(posedge clk ) begin
        PC_M <= PC_E;
        ALU_out_M <= ALU_out_E;
        WD_M <= WD_E;
        Instruction_M <= Instruction_E;
        wr_enM <= wr_enE;
        rd_enM <= wr_enE;
        wb_selM <= wb_selE;
        reg_wrM <= reg_wrE;
    end

endmodule