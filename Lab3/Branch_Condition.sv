module Branch_Condition (
    output reg br_taken,
    input [31:0] A, B,
    input [2:0] br_type
);

    always_comb begin 
        case(br_type)
            0: br_taken <= A == B;
            1: br_taken <= A != B;
            2: br_taken <= A < B;
            3: br_taken <= A > B;
            4: br_taken <= A <= B;
            5: br_taken <= A >= B;
            6: br_taken <= 1;
        default: br_taken <= 0;
        endcase
    end
    
endmodule