module Decode (
    output reg [31:0] PC_D, Instruction_D,
    input [31:0] PC, Instruction, input clk
);
    always @(posedge clk ) begin
        PC_D <= PC;
        Instruction_D <= Instruction;
    end
    
endmodule