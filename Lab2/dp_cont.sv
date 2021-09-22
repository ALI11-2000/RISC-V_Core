module dp_cont (
    input clk, rst,
    output reg [3:0] num0, num1, num2, num3,
    output reg done
);

    always @(posedge clk) begin
        if(rst)
            num0 <= 4'b12;
        else
            num0 <= num0_in;
    end
    
endmodule