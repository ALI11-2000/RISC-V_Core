module mux31 (
    output reg [31:0] out, input [31:0] a,b,c, input [1:0] sel
);

    always_comb begin 
        case (sel)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c; 
            default: out = b;
        endcase
    end
    
endmodule