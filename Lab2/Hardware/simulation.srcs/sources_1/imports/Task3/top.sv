module top (
    output reg [6:0] seg, output reg [7:0] ano ,
    input [3:0] A , B,input clk,rst
);
    wire [7:0] R;
    tasks a1(A,B,R);

    wire [3:0] R1, R2, R3;
    BCD a2(.binary(R),.Hundreds(R1), .Tens(R2), .Ones(R3));

    clkdiv a3(.clock_in(clk),.clock_out(new_clk));

    reg [1:0] sel;

    always @(posedge new_clk) begin
        if(rst) begin
            ano[7] <= 0;
            ano[6] <= 1;
            ano[5] <= 1;
        end else begin
            ano[7] <= ano[5]; 
            ano[6] <= ano[7];
            ano[5] <= ano[6];
        end
    end

    always @(*) begin
        case (ano[7:5])
            3'b011: sel = 2'b00;
            3'b101: sel = 2'b01;
            3'b110: sel = 2'b10;
            default: sel = 2'b10;
        endcase
    end

    reg [3:0] Res;
    always @(*) begin
        if(sel == 2'b00)
            Res <= R1;
        if(sel == 2'b01)
            Res <= R2;
        if(sel == 2'b10)
            Res <= R3;
        ano[4:0] = 5'b11111;
    end
    
    always @(*) begin
        case(Res)
        4'b0000: seg = 7'b0000001; // "0"     
        4'b0001: seg = 7'b1001111; // "1" 
        4'b0010: seg = 7'b0010010; // "2" 
        4'b0011: seg = 7'b0000110; // "3" 
        4'b0100: seg = 7'b1001100; // "4" 
        4'b0101: seg = 7'b0100100; // "5" 
        4'b0110: seg = 7'b0100000; // "6" 
        4'b0111: seg = 7'b0001111; // "7" 
        4'b1000: seg = 7'b0000000; // "8"     
        4'b1001: seg = 7'b0000100; // "9"
		4'b1010: seg = 7'b0001000; // "A"     
        4'b1011: seg = 7'b1100000; // "b"     
        4'b1100: seg = 7'b0110001; // "C"     
        4'b1101: seg = 7'b1000010; // "d"     
        4'b1110: seg = 7'b0110000; // "E"     
        4'b1111: seg = 7'b0111000; // "F"     
        default: seg = 7'b0000001; // "0"
        endcase
    end
endmodule