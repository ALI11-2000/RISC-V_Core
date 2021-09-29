module half_adder #(
    parameter Width=2
) (
    input [Width-1:0] A,B,
    output [Width-1:0] S,output C
);

   xor a1(S[0],A[0],B[0]);
   and a2(X,A[0],B[0]);

   xor a3(S[1],A[1],B[1],X);
   xor a6(Z,A[1],B[1]);
   and a4(Y,A[1],B[1]);

   and a8(I,X,Z);

   or a5(C,I,Y);

   initial begin
       $dumpfile("dump.vcd");
       $dumpvars;
   end

endmodule