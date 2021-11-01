module Controller (
    input [31:0] Instruction,
    output reg [3:0] alu_op,output reg reg_wr, sel_A, sel_B,
    wr_en, rd_en, unsign,output reg [2:0] br_type, output reg [1:0] wb_sel
);  
    wire [6:0] opcode, func7 ;
    wire [2:0] func3;
    assign opcode = Instruction[6:0];
    assign func7 = Instruction[31:25];
    assign func3 = Instruction[14:12];
    always_comb begin 
        alu_op = 0;
        reg_wr = 0;
        sel_A = 0;
        sel_B = 0;
        wr_en = 0;
        rd_en = 0;
        wb_sel = 0;
        br_type = 3'b111;
        unsign = 0;
        case (opcode)
            // I type load
            7'd3: begin
                reg_wr = 1;
                sel_B = 1;
                rd_en = 1;
                wb_sel = 2;
            end
            // S type sw only
            7'd35: begin
                sel_B = 1;
                wr_en = 1;
                wb_sel = 2;
            end
            // I type
            7'd19: begin
                reg_wr = 1;
                sel_B = 1;
                rd_en = 1;
                wb_sel = 1;
                case (func3)
                    7'd0: alu_op = 0;
                    7'd1: begin
                        alu_op = 1;
                        unsign = 1;
                    end 
                    7'd2: begin
                        alu_op = 10;
                    end
                    7'd3: begin
                        alu_op = 10;
                        unsign = 1;
                    end
                    7'd4: begin
                        alu_op = 2;
                    end
                    7'd5: begin
                        case(func7)
                        7'b0 : alu_op = 3;
                        7'b0100000: alu_op = 4;
                        default: alu_op = 3;
                        endcase
                    end
                    7'd6: alu_op = 5;
                    7'd7: alu_op = 6;
                    default: alu_op = 0;
                endcase
            end
            // U Type auipc
            7'd23: begin 
                alu_op = 0;
                sel_A = 1;
                sel_B = 1;
                br_type = 6;
            end
            // U Type lui
            7'd55: begin
                alu_op = 9;
                reg_wr = 1;
                sel_B = 1;
                rd_en = 1;
                wb_sel = 1;
            end
            // R Type
            7'd51: begin
                reg_wr = 1;
                rd_en = 1;
                wb_sel = 1;
                case (func3)
                    7'd0:begin
                        case (func7)
                            7'b0: alu_op = 0;
                            7'b0100000: alu_op = 7;
                            default: alu_op = 0;
                        endcase
                    end 
                    7'd1: begin
                        alu_op = 1;
                    end 
                    7'd2: begin
                        alu_op = 10;
                    end
                    7'd3: begin
                        alu_op = 10;
                        unsign = 1;
                    end
                    7'd4: begin
                        alu_op = 2;
                    end
                    7'd5: begin
                        case(func7)
                        7'd0 : alu_op = 3;
                        7'b0100000: alu_op = 4;
                        default: alu_op = 3;
                        endcase
                    end
                    7'd6: alu_op = 5;
                    7'd7: alu_op = 6;
                    default: alu_op = 0;
                endcase
            end
            // B Type
            7'd99: begin
                sel_A = 1;
                sel_B = 1;
                case(func3)
                    0: br_type = 0;
                    1: br_type = 1;
                    4: br_type = 2;
                    5: br_type = 3;
                    6: br_type = 4;
                    7: br_type = 5;
                default: br_type = 7;
                endcase
            end 
            // I JALR
            7'd103: begin
                sel_A = 1;
                sel_B = 1;
                wb_sel = 1;
                reg_wr = 1;
                br_type = 6;
            end
            // J Type
            7'd111: begin
                sel_A = 1;
                sel_B = 1;
                br_type = 6;
                reg_wr = 1;
                wb_sel = 0;
            end
            //default: 
        endcase
    end
    
endmodule