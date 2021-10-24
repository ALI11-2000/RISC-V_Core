module Data_Memory (
    output reg [31:0] result,
    output reg [31:0] rdata,
    input [31:0] wdata, addr, num1, num2,
    input wr_en, rd_en, clk, rst, hard_write
);

    reg [8:0] data_mem [255:0];
    integer i;
    reg [31:0] a1, a2;

    always @(*) begin
        if(rd_en)
            rdata <= {data_mem[addr],data_mem[addr+1],data_mem[addr+2],data_mem[addr+3]};
        a1 <= {data_mem[0],data_mem[0+1],data_mem[0+2],data_mem[0+3]};
        a2 <= {data_mem[4],data_mem[4+1],data_mem[4+2],data_mem[4+3]};
    end

    always @(posedge clk) begin
            result <= {data_mem[8],data_mem[8+1],data_mem[8+2],data_mem[8+3]};
    end

    always @(posedge clk) begin
        if(rst) begin
            for(i=0;i<=255;i=i+1) begin
                data_mem[i] <= 0;
            end
            {data_mem[0],data_mem[0+1],data_mem[0+2],data_mem[0+3]} <= num1;
            {data_mem[4],data_mem[4+1],data_mem[4+2],data_mem[4+3]} <= num2;
        end else begin
            if(wr_en)
                {data_mem[addr],data_mem[addr+1],data_mem[addr+2],data_mem[addr+3]} <= wdata; 
        end
    end
    
endmodule