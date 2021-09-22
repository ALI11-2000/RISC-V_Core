`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2021 08:09:43 PM
// Design Name: 
// Module Name: tb_dp_cont
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_dp_cont;
    reg clk, ready, rst1;
    reg [3:0] no0, no1, no2, no3;
    wire [3:0] num0, num1, num2, num3;
    dp_cont dut(clk, ready, rst1,no0, no1, no2, no3,num0, num1, num2, num3,done);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst1 = 1;
        no0= 4'd2;
        no1= 4'd5;
        no2= 4'd4;
        no3= 4'd1;
        repeat(2) @(posedge clk);
        rst1 = 0;
        ready = 1;
        repeat(2) @(posedge clk);
        ready = 0;
        @(posedge done);
        repeat(2) @(posedge clk);
        no0= 4'd4;
                no1= 4'd7;
                no2= 4'd5;
                no3= 4'd4;
                repeat(2) @(posedge clk);
                rst1 = 0;
                ready = 1;
                repeat(2) @(posedge clk);
                ready = 0;
                @(posedge done);
                repeat(2) @(posedge clk);
        $stop;
    end

endmodule
