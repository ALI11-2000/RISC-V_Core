`timescale 1ns/1ns

module top(
    input [31:0] num1, num2, 
    input clk, rst, hard_write,
    output [31:0] result
);
    
    wire[31:0] rdata1, rdata2;
    wire [31:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31;
    wire [4:0] raddr1, raddr2, waddr;
    reg [31:0] wdata;
    wire [31:0] Instruction, PC, PC_next, ALU_out, Immediate_Value, rdata;
    reg [31:0] A, B;
    wire [3:0] alu_op;
    wire [2:0] br_type;
    wire [1:0] wb_sel;
    wire sel_A, sel_B;

    Register_File rf(.rdata1(rdata1), .rdata2(rdata2), 
    .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8), .x9(x9), .x10(x10), .x11(x11), .x12(x12), .x13(x13), .x14(x14),
    .x15(x15), .x16(x16), .x17(x17), .x18(x18), .x19(x19), .x20(x20), .x21(x21), .x22(x22), .x23(x23), .x24(x24), .x25(x25), .x26(x26), .x27(x27),
    .x28(x28), .x29(x29), .x30(x30), .x31(x31),
    .raddr1(Instruction[19:15]), .raddr2(Instruction[24:20]), .waddr(Instruction[11:7]), .wdata(wdata), .clk(clk), .rst(rst), .reg_wr(reg_wr));

    //Instruction_Memory im(.Instruction(Instruction), .Address(PC));
    xpm_memory_spram #(
         .ADDR_WIDTH_A(6),              // DECIMAL
         .AUTO_SLEEP_TIME(0),           // DECIMAL
         .BYTE_WRITE_WIDTH_A(32),       // DECIMAL
         .ECC_MODE("no_ecc"),           // String
         .MEMORY_INIT_FILE("instruction_mem.mem"),     // String
         .MEMORY_INIT_PARAM("0"),       // String
         .MEMORY_OPTIMIZATION("true"),  // String
         .MEMORY_PRIMITIVE("block"),     // String
         .MEMORY_SIZE(2048),            // DECIMAL
         .MESSAGE_CONTROL(0),           // DECIMAL
         .READ_DATA_WIDTH_A(32),        // DECIMAL
         .READ_LATENCY_A(1),            // DECIMAL
         .READ_RESET_VALUE_A("0"),      // String
         .USE_MEM_INIT(1),              // DECIMAL
         .WAKEUP_TIME("disable_sleep"), // String
         .WRITE_DATA_WIDTH_A(32),       // DECIMAL
         .WRITE_MODE_A("read_first")    // String
      )
      xpm_memory_spram_inst (
         .dbiterra(dbiterra),             // 1-bit output: Status signal to indicate double bit error occurrence
                                          // on the data output of port A.
    
         .douta(Instruction),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
         .sbiterra(sbiterra),             // 1-bit output: Status signal to indicate single bit error occurrence
                                          // on the data output of port A.
    
         .addra(PC_next[5:0]/4),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
         .clka(clk),                     // 1-bit input: Clock signal for port A.
         .dina(dina),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
         .ena(1'b1),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                          // cycles when read or write operations are initiated. Pipelined
                                          // internally.
    
         .injectdbiterra(injectdbiterra), // 1-bit input: Controls double bit error injection on input data when
                                          // ECC enabled (Error injection capability is not available in
                                          // "decode_only" mode).
    
         .injectsbiterra(injectsbiterra), // 1-bit input: Controls single bit error injection on input data when
                                          // ECC enabled (Error injection capability is not available in
                                          // "decode_only" mode).
    
         .regcea(1'b1),                 // 1-bit input: Clock Enable for the last register stage on the output
                                          // data path.
    
         .rsta(rsta),                     // 1-bit input: Reset signal for the final port A output register stage.
                                          // Synchronously resets output port douta to the value specified by
                                          // parameter READ_RESET_VALUE_A.
    
         .sleep(sleep),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
         .wea(1'b0)                        // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                                          // data port dina. 1 bit wide when word-wide writes are used. In
                                          // byte-wide write configurations, each bit controls the writing one
                                          // byte of dina to address addra. For example, to synchronously write
                                          // only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
                                          // 4'b0010.
          );

    Program_Counter pc(.ALU_out(ALU_out), .br_taken(br_taken), .clk(clk), .rst(rst), .PC_next(PC_next), .PC(PC), .hard_write(hard_write));

    Immediate_Generator ig(.Immediate_Value(Immediate_Value), .Instruction(Instruction), .unsign(unsign));

    always @(*) begin
        A <= sel_A ? PC : rdata1;
        B <= sel_B ? Immediate_Value : rdata2;
    end
    

    ALU al(.ALU_out(ALU_out),.A(A), .B(B),.alu_op(alu_op));

    Branch_Condition bcond(.br_taken(br_taken), .A(rdata1), .B(rdata2), .br_type(br_type));

    Data_Memory dmem(.num1(num1), .num2(num2), .result(result), .hard_write(hard_write),
                     .rdata(rdata), .wdata(rdata2), .addr(ALU_out),
                     .wr_en(wr_en), .rd_en(rd_en), .clk(clk), .rst(rst));


    always_comb begin 
        case (wb_sel)
            0 : wdata <=  PC + 4;
            1 : wdata <= ALU_out;
            2 : wdata <= rdata;
        endcase
    end 

    Controller cont(.Instruction(Instruction), .alu_op(alu_op), .reg_wr(reg_wr), .sel_A(sel_A), .sel_B(sel_B),
    .wr_en(wr_en), .rd_en(rd_en), .br_type(br_type), .wb_sel(wb_sel), .unsign(unsign));  

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
    
endmodule