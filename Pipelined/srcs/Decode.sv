module Decode (
    output reg [31:0] PC_D, Instruction_D,
    input [31:0] PC, Instruction, input clk, StallD, FlushD, rst
);
    always @(posedge clk ) begin
        if(FlushD || rst) begin
            PC_D <= 0;
            Instruction_D <= 0;
        end else begin
        if(!StallD) begin
            PC_D <= PC;
            Instruction_D <= Instruction;
        end
        end
    end
    
endmodule