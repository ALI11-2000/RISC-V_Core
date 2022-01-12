module LSU (
    input [2:0] rd_en, wr_en, input [31:0] address, wdata, rdata_in,
    output reg [31:0] rdata_out, wdata_out, address_out, output reg [2:0] wr_en_out
);
    // 3'd0: rd_en = 3'd1;// b
    // 3'd1: rd_en = 3'd2;// h
    // 3'd2: rd_en = 3'd3;// w
    // 3'd4: rd_en = 3'd4;// bu
    // 3'd5: rd_en = 3'd5;// hu
    always @(*) begin
        wr_en_out = wr_en;
        address_out = address;
        case (wr_en)
            3'd1: wdata_out = {{24'b0},{wdata[7:0]}};
            3'd2: wdata_out = {{16'b0},{wdata[15:0]}};
            3'd3: wdata_out = wdata;
            default: wdata_out = 0;
        endcase
        case (rd_en)
            3'd1: rdata_out = {{24{rdata_in[7]}},{rdata_in[7:0]}};
            3'd2: rdata_out = {{16{rdata_in[15]}},{rdata_in[15:0]}}; 
            3'd3: rdata_out = rdata_in; 
            3'd4: rdata_out = {{24'b0},{rdata_in[7:0]}}; 
            3'd5: rdata_out = {{16'b0},{rdata_in[15:0]}};  
            default: rdata_out = 0;
        endcase
    end
    
endmodule