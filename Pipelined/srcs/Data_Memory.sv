module Data_Memory (
    output reg [31:0] result,
    output reg [31:0] rdata,
    input [31:0] wdata, addr, num1, num2,
    input [2:0] wr_en, rd_en, input clk, rst, hard_write
);

    reg [8:0] data_mem [255:0];
    integer i,j;

 

    always @(*) begin
        case (rd_en)
            1: rdata <= {{24'd0},data_mem[addr]};
            2: rdata <= {{16'd0},data_mem[addr],data_mem[addr+1]};
            3: rdata <= {data_mem[addr],data_mem[addr+1],data_mem[addr+2],data_mem[addr+3]};
        endcase
    end

    always @(posedge clk) begin
            result <= {data_mem[8],data_mem[8+1],data_mem[8+2],data_mem[8+3]};
    end

    always @(posedge clk) begin
        if(rst) begin
            for(i=0;i<=255;i=i+1) begin
                data_mem[i] <= 0;
            end
        end else begin
             case (wr_en)
            3'd1: data_mem[addr] = wdata[7:0];
            3'd2: {data_mem[addr],data_mem[addr+1]} = wdata[15:0];
            3'd3: {data_mem[addr],data_mem[addr+1],data_mem[addr+2],data_mem[addr+3]} = wdata;
            endcase
        end
    end
    
    initial begin
        $dumpfile("dump.vcd");
        for (j = 0; j<=255; j=j+1) begin
            $dumpvars(0,data_mem[j]);
        end
    end
    
endmodule