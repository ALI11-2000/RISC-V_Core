module Writeback (
    output reg [31:0] PC_W, ALU_out_W, RD_W, Instruction_W,
    output reg reg_wrW, output reg [1:0] wb_selW,
    input [31:0] PC_M, ALU_out_M, RD_M, Instruction_M,
    input reg_wrM, input [1:0] wb_selM, input clk
);
    always @(posedge clk ) begin
        PC_W <= PC_M;
        ALU_out_W <= ALU_out_M;
        RD_W <= RD_M;
        Instruction_W <= Instruction_M;
        wb_selW <= wb_selM;
        reg_wrW <= reg_wrM;
    end

endmodule