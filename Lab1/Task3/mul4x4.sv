module mul4x4 #(
    parameter Width = 4
) (
    input [Width-1:0] A, B,
    output reg [2*Width-1:0] R
);
    reg [Width-1:0] X1,X2,X3,X0;
    reg [2*Width-1:0] Y1,Y2,Y3,Y0;
    always @(*) begin
        X0 = A & {Width{B[0]}};
        X1 = A & {Width{B[1]}};
        X2 = A & {Width{B[2]}};
        X3 = A & {Width{B[3]}};
    end

    always @(*) begin
        Y0 = {4'b0000,X0};
        Y1 = {3'b0000,X1,1'b0};
        Y2 = {2'b0000,X2,2'b0};
        Y3 = {1'b0000,X3,3'b0};

        R = Y0 + Y1 + Y2 + Y3;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule