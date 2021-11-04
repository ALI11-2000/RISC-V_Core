`timescale 1ns / 1ps

module simulation;

    reg [31:0] num1, num2;
    reg clk, rst, hard_write;
    wire [31:0] result;
    
    top dut(num1, num2, clk, rst, hard_write, result);
    
    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end
    
    initial begin
        num1 = 2;
        num2 = 4;
        rst = 1;
        repeat(2) @(posedge clk);
        rst = 0;
        hard_write = 1;
        repeat(2) @(posedge clk);
        hard_write = 0;
        while(dut.PC != 32'd44) begin
            @(posedge clk);
            $display("value of PC is %0d",dut.PC);
        end
        @(posedge clk);
        $display("final value of PC is %0d",dut.PC);
        
        
        num1 = 30;
        num2 = 15;
        hard_write = 1;
        repeat(2) @(posedge clk);
        hard_write = 0;
        while(dut.PC != 32'd44) begin
            @(posedge clk);
            $display("value of PC is %0d",dut.PC);
        end
        @(posedge clk);
        $display("final value of PC is %0d",dut.PC);
        $stop;
    end
    
endmodule
