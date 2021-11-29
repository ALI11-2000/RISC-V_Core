module timer (
    output reg interrupt, 
    input clk, rst
);
    reg [31:0] value;

    always @(posedge clk ) begin
        if(rst || value == 10) begin
            value <= 0;
        end else begin
            value <= value + 1;
        end
    end

    always_comb begin
        if(value == 10) begin
            interrupt = 1;
        end else begin
            interrupt = 0;
        end
    end
    
endmodule