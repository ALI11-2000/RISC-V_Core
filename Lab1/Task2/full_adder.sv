`include "half_adder.sv"
module full_adder #(
    parameter Width=2
) (
    input [Width-1:0] A,B,C_in,
    output [Width-1:0] S,output C_out
);

    wire [1:0] X;
    wire Y,Z;

    half_adder a1 (.A(C_in),.B(X),.S(S),.C(Y));
    half_adder a2(.A(A),.B(B),.S(X),.C(Z));

    or a3(C_out,Y,Z);

   initial begin
       $dumpfile("dump.vcd");
       $dumpvars;
   end

endmodule