module Data_Memory (
    output reg [31:0] rdata,
    input [31:0] wdata, addr,
    input wr_en, rd_en, clk, rst
);

    reg [8:0] data_mem [255:0];
    integer i;

    always @(*) begin
        if(rd_en)
            rdata <= {data_mem[addr],data_mem[addr+1],data_mem[addr+2],data_mem[addr+4]};
    end

    always @(posedge clk) begin
        if(rst) begin
            for(i=0;i<=255;i=i+1)
                data_mem[i] <= 0;
        end else begin
            if(wr_en)
                {data_mem[addr],data_mem[addr+1],data_mem[addr+2],data_mem[addr+4]} <= wdata; 
        end
    end
    
endmodule