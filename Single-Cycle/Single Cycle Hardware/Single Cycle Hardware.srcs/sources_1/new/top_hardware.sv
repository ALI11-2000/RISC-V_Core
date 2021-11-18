`timescale 1ns / 1ns

module top_hardware(input [4:0] num1_in, num2_in, 
                    input rst, clk, hard_write,
                    output reg [6:0] LED_out, output reg [7:0] ano
                    );
    wire [31:0] num1, num2, douta;
    
    assign num1 = {{27'b0},num1_in};
    assign num2 = {{27'b0},num2_in};
    
    top t1(num1, num2, clk_new, rst, hard_write, douta);
    
    Clock_divider dut(.clock_in(clk),.clock_out(clk_new));
    
    reg [31:0] counter;		
    reg toggle = 0;             
    
    reg [3:0] out;
                     
         always @(posedge clk)
             begin
                 if(rst) begin
                     counter <= 0;
                 end
                 else begin
                     if(counter>=100000) begin//100000
                          counter <= 0;
                          toggle = ~toggle; end
                     else begin
                         counter <= counter + 1;
                         end
                 end
             end 
         always@(posedge toggle or posedge rst) begin
            if(rst) begin
                ano <= 8'b01111111;
            end
            else begin
                ano[7] <= ano[6];
                ano[6] <= ano[5];
                ano[5] <= ano[4];
                ano[4] <= ano[3];
                ano[3] <= ano[2];
                ano[2] <= ano[1];
                ano[1] <= ano[0];
                ano[0] <= ano[7];
            end
         end
         always@(*) begin
            case(ano)
            8'b01111111: out=douta[31:28];
            8'b10111111: out=douta[27:24];
            8'b11011111: out=douta[23:20];
            8'b11101111: out=douta[19:16];
            8'b11110111: out=douta[15:12];
            8'b11111011: out=douta[11:8];
            8'b11111101: out=douta[7:4];
            8'b11111110: out=douta[3:0];
            default:out=douta[3:0];
            endcase
         end
         
         always @(*)begin
             case(out)                
             4'b0000: LED_out = 7'b0000001; // "0"     
             4'b0001: LED_out = 7'b1001111; // "1" 
             4'b0010: LED_out = 7'b0010010; // "2" 
             4'b0011: LED_out = 7'b0000110; // "3" 
             4'b0100: LED_out = 7'b1001100; // "4" 
             4'b0101: LED_out = 7'b0100100; // "5" 
             4'b0110: LED_out = 7'b0100000; // "6" 
             4'b0111: LED_out = 7'b0001111; // "7" 
             4'b1000: LED_out = 7'b0000000; // "8"     
             4'b1001: LED_out = 7'b0000100; // "9"
             4'b1010: LED_out = 7'b0001000; // "A"     
             4'b1011: LED_out = 7'b1100000; // "b"     
             4'b1100: LED_out = 7'b0110001; // "C"     
             4'b1101: LED_out = 7'b1000010; // "d"     
             4'b1110: LED_out = 7'b0110000; // "E"     
             4'b1111: LED_out = 7'b0111000; // "F"     
             
             default: LED_out = 7'b0000001; // "0"
         endcase
         end


endmodule
