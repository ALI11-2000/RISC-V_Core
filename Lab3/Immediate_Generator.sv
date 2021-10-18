module Immediate_Generator (
    output reg [31:0] Immediate_Value,
    input [31:0] Instruction,
    input unsign
);
    wire [6:0] opcode;
    assign opcode = Instruction[6:0];
    always_comb begin 
       // Using Opcode
        case (opcode)
            // I Type Instruction
            7'd3,7'd19,7'd103: Immediate_Value <= unsign ? {{20'b0}, Instruction[31:20]} : {{20{Instruction[31]}}, Instruction[31:20]};
            // S Type Instruction
            7'd35: Immediate_Value <= {{20{Instruction[31]}}, Instruction[31:25], Instruction[11:7]};
            // B Type Instruction
            7'd99: Immediate_Value <= {{20{Instruction[31]}}, Instruction[7], Instruction[30:25], Instruction[11:8], 1'b0};
            // J Type Instruction
            7'd111: Immediate_Value <= {{12{Instruction[31]}}, Instruction[19:12], Instruction[20], Instruction[30:21], 1'b0};
            // U Type Instruction
            7'd23,7'd55: Immediate_Value <= {Instruction[31:12],12'b0};
            default: Immediate_Value <= 0;
        endcase
    end
endmodule