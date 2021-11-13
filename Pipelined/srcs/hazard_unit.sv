module hazard_unit (
    output reg [1:0] For_A, For_B, output reg StallD, StallF, FlushE, FlushD,
    input reg_wrM, reg_wrW, br_taken, input [1:0] wb_selE,
    input [31:0] Instruction_E, Instruction_M, Instruction_W, Instruction_D
);

    wire [4:0] rs1_E, rs2_E, rd_M, rd_W, rd_E, rs1_D, rs2_D;

    assign rs1_D = Instruction_D[19:15];
    assign rs2_D = Instruction_D[24:20];    
    assign rs1_E = Instruction_E[19:15];
    assign rs2_E = Instruction_E[24:20];
    assign rd_E = Instruction_E[11:7];
    assign rd_M = Instruction_M[11:7];
    assign rd_W = Instruction_W[11:7];
    

    always_comb begin 
        For_A = 0;
        For_B = 0;
        StallD = 0;
        StallF = 0;
        FlushE = 0;
        FlushD = 0;
        if(wb_selE == 2'b10 && (rs1_D == rd_E || rs2_D == rd_E )) begin
                StallF = 1;
                StallD = 1;
                FlushE = 1;
        end 

        if(br_taken) begin
            FlushD = 1;
            FlushE = 1;
        end

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