module Program_Counter (
    input [31:0] ALU_out, epc_evec,
    input br_taken, clk, rst, hard_write, StallF, csr,
    output reg [31:0] PC, output [31:0] PC_next
);
    wire [31:0] PC_next1;
    assign PC_next1 = br_taken ? ALU_out : PC + 4;
    assign PC_next = csr ? epc_evec : PC_next1;
    always @(posedge clk ) begin
        if(rst || hard_write)
            PC <= 0;
        else if(!StallF)
            PC <= PC_next;
    end
    
endmodule