module ALU (
    output reg [31:0] ALU_out,
    input [31:0] A, B,
    input [3:0] alu_op
);
    always_comb begin 
        case(alu_op)
            0: ALU_out <= A + B;// addi
            1: ALU_out <= A << B;// slli
            2: ALU_out <= A ^ B;// xor
            3: ALU_out <= A >> B;// srli
            4: ALU_out <= A >>> B;// srai
            5: ALU_out <= A | B;// or
            6: ALU_out <= A & B;// and
            7: ALU_out <= A - B;
            8: ALU_out <= A;
            9: ALU_out <= B;
        default: ALU_out <= A + B;
        endcase
    end
    
endmodule