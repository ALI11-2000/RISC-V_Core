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
    reg [1:0] sel1;
    reg clk,rst, write,order,ready;
    reg [3:0] num;
    wire [6:0] seg;
    wire [7:0] ano;
    
    top dut(seg, ano ,num ,  sel1,clk,rst, write,order,ready
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        num = 4'd12;
        sel1 = 2'd1;
        write = 1;
        order = 0;
        ready = 0;
        repeat(2) @(posedge clk);
        rst = 0;
        write = 0;
        repeat(2) @(posedge clk);
        num = 4'd2;
        sel1 = 2'd2;
        write = 1;
        order = 0;
        ready = 0;
        repeat(2) @(posedge clk);
        write = 0;
        repeat(2) @(posedge clk);
        ready = 1;
        order = 1;
                repeat(2) @(posedge clk);
                ready = 0;
        repeat(42) @(posedge clk);
        $stop;
    end

endmodule
