module Writeback (
    output reg [31:0] PC_W, ALU_out_W, RD_W, Instruction_W,
    output reg reg_wrW, output reg [1:0] wb_selW,
    input [31:0] PC_M, ALU_out_M, RD_M, Instruction_M,
    input reg_wrM, input [1:0] wb_selM, input clk, rst
);
    always @(posedge clk ) begin
        if (rst) begin
            PC_W <= 0;
            ALU_out_W <= 0;
            RD_W <= 0;
            Instruction_W <= 0;
            wb_selW <= 0;
            reg_wrW <= 0;
        end else begin
            PC_W <= PC_M;
            ALU_out_W <= ALU_out_M;
            RD_W <= RD_M;
            Instruction_W <= Instruction_M;
            wb_selW <= wb_selM;
            reg_wrW <= reg_wrM;
        end
    end

endmodule