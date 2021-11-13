module fowarding_unit (
    output reg [1:0] For_A, For_B, 
    input reg_wrM, reg_wrW,
    input [31:0] Instruction_E, Instruction_M, Instruction_W
);

    wire [5:0] rs1_E, rs2_E, rd_M, rd_W;

     
    assign rs1_E = Instruction_E[19:15];
    assign rs2_E = Instruction_E[24:20];
    assign rd_M = Instruction_M[11:7];
    assign rd_W = Instruction_W[11:7];
    

    always_comb begin 
        For_A = 0;
        For_B = 0;
        
        if (rs1_E == rd_M && reg_wrM && rs1_E != 5'b0) begin
            For_A = 2'd1;
        end else begin
            if (rs1_E == rd_W && reg_wrW && rs1_E != 5'b0) begin
            For_A = 2'd2;
            end
        end

        if (rs2_E == rd_M && reg_wrM && rs2_E != 5'b0) begin
            For_B = 2'd1;
        end else begin
            if (rs2_E == rd_W && reg_wrW && rs2_E != 5'b0) begin
            For_B = 2'd2;
        end
        end
    end

endmodule