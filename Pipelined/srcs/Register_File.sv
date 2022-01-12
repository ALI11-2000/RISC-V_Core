module Register_File (
    output reg [31:0] rdata1, rdata2,
    output reg [31:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,
    input [4:0] raddr1, raddr2, waddr,
    input [31:0] wdata,
    input clk, rst, reg_wr
);
    integer i;
    reg [31:0] register_file [31:0];
    always @(negedge clk ) begin
        if(rst) begin
            for (i = 0; i <= 31; i=i+1) begin
                if(i==2) begin
                    register_file[i] <= 32'd255;
                end else begin
                    register_file[i] <= 0;
                end
            end
        end else if(reg_wr) begin
            if(waddr != 0)
                register_file[waddr] <= wdata;
        end 
    end

    always @(*) begin
        rdata1 <= register_file[raddr1];
        rdata2 <= register_file[raddr2];
        x0 <= register_file[0];
        x1 <= register_file[1];
        x2 <= register_file[2];
        x3 <= register_file[3];
        x4 <= register_file[4];
        x5 <= register_file[5];
        x6 <= register_file[6];
        x7 <= register_file[7];
        x8 <= register_file[8];
        x9 <= register_file[9];
        x10 <= register_file[10];
        x11 <= register_file[11];
        x12 <= register_file[12];
        x13 <= register_file[13];
        x14 <= register_file[14];
        x15 <= register_file[15];
        x16 <= register_file[16];
        x17 <= register_file[17];
        x18 <= register_file[18];
        x19 <= register_file[19];
        x20 <= register_file[20];
        x21 <= register_file[21];
        x22 <= register_file[22];
        x23 <= register_file[23];
        x24 <= register_file[24];
        x25 <= register_file[25];
        x26 <= register_file[26];
        x27 <= register_file[27];
        x28 <= register_file[28];
        x29 <= register_file[29];
        x30 <= register_file[30];
        x31 <= register_file[31];
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
    
endmodule