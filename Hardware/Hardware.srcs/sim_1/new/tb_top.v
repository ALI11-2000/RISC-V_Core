`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2021 09:44:21 PM
// Design Name: 
// Module Name: tb_top
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


module tb_top;
    wire [6:0] seg;
    wire [7:0] ano;
    reg clk,rst;
    reg [3:0] A,B;
    
    top dut(seg,ano ,A , B,clk,rst);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin 
        rst = 1;
        repeat(2) @(posedge clk);
        rst = 0;
        A = 4'd15;
        B = 4'd15;
        repeat(12) @(posedge clk);
        $stop;
    end
endmodule
