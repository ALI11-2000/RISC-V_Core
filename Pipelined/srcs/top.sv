`include "../srcs/top_core.sv"
`include "../srcs/Instruction_Memory.sv"
module top (
    input clk,
    input rst
);

    wire [31:0] Instruction, PC;

    Instruction_Memory im(.Instruction(Instruction), .Address(PC));

    top_core proc(
    .Instruction(Instruction),
    .PC(PC),
    .clk(clk),
    .rst(rst)
);
    
endmodule