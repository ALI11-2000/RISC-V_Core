`timescale 1ns / 1ps

module simulation_hardware;

    reg [4:0] num1, num2;
    reg clk, rst, hard_write;
    wire [6:0] LED_out;
    wire [7:0] Anode_Activate;
    
    top_hardware dut( num1, num2,rst, clk, hard_write,LED_out, Anode_Activate);
    
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
        while(dut.t1.PC != 32'd44) begin
            @(posedge clk);
            $display("value of PC is %0d",dut.t1.PC);
        end
        @(posedge clk);
        $display("final value of PC is %0d",dut.t1.PC);
        
        
        num1 = 30;
        num2 = 15;
        hard_write = 1;
        repeat(2) @(posedge clk);
        hard_write = 0;
        while(dut.t1.PC != 32'd44) begin
            @(posedge clk);
            $display("value of PC is %0d",dut.t1.PC);
        end
        @(posedge clk);
        $display("final value of PC is %0d",dut.t1.PC);
        $stop;
    end
    
endmodule
