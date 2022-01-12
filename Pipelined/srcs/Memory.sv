module Memory (
    output reg [31:0] PC_M, ALU_out_M, WD_M,
    Instruction_M, output reg reg_wrM, output reg [2:0] wr_enM,
    rd_enM, output reg [1:0] wb_selM,
    input [31:0] PC_E, ALU_out_E, WD_E,
    Instruction_E, input reg_wrE, rst, input [2:0] rd_enE, wr_enE, input [1:0] wb_selE, input clk
);

    always @(posedge clk ) begin
        if(rst) begin
            PC_M <= 0;
            ALU_out_M <= 0;
            WD_M <= 0;
            Instruction_M <= 0;
            wr_enM <= 0;
            rd_enM <= 0;
            wb_selM <= 0;
            reg_wrM <= 0;
        end else begin
            PC_M <= PC_E;
            ALU_out_M <= ALU_out_E;
            WD_M <= WD_E;
            Instruction_M <= Instruction_E;
            wr_enM <= wr_enE;
            rd_enM <= rd_enE;
            wb_selM <= wb_selE;
            reg_wrM <= reg_wrE;
        end
    end

endmodule