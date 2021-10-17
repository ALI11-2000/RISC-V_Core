module Instruction_Memory (
    output reg [31:0] Instruction,
    input [31:0] Address
);
    reg [31:0] instruction_mem [50:0];
    $readmemh("instruction_mem.mem",instruction_mem);

    always @(*) begin
        Instruction <= instruction_mem(Address/4);
    end
    
endmodule