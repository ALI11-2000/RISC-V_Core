module dp_cont (
    input clk, ready, rst1,
    input [3:0] no0, no1, no2, no3,
    output reg [3:0] num0, num1, num2, num3,
    output reg done
);
    
    reg [3:0] num0_in, num1_in, num2_in, num3_in;
    reg mux0, mux3, rst, d_mux, c_mux;
    reg [1:0] mux1, mux2, c ,d;
    reg swap;
    reg [1:0] comp_mux;
    reg [3:0] ad,ad1;
    reg [3:0] cmp1, cmp2;
    reg [3:0] cs,ns;

    always @(posedge clk) begin
        if(rst)
            num0 <= no0;
        else
            num0 <= num0_in;
    end

    always @(*) begin
        num0_in <= mux0 ? num1 : num0;
    end

    always @(posedge clk) begin
        if(rst)
            num1 <= no1;
        else
            num1 <= num1_in;
    end

    always @(*) begin
        case (mux1)
            2'b00: num1_in = num1;
            2'b01: num1_in = num0;
            2'b10: num1_in = num2; 
            default: num1_in = num1;
        endcase
    end

    always @(posedge clk) begin
        if(rst)
            num2 <= no2;
        else
            num2 <= num2_in;
    end

    always @(*) begin
        case (mux2)
            2'b00: num2_in = num2;
            2'b01: num2_in = num1;
            2'b10: num2_in = num3; 
            default: num2_in = num2;
        endcase
    end
   
    always @(posedge clk) begin
        if(rst)
            num3 <= no3;
        else
            num3 <= num3_in;
    end

    always @(*) begin
        num3_in <= mux3 ? num2 : num3;
    end

    always @(*) begin
        if(swap == 0) begin
            mux0 = 0;
            mux1 = 2'b00;
            mux2 = 2'b00;
            mux3 = 0;
        end
        else begin
            if (d == 2'b00) begin
                mux0 = 1;
                mux1 = 2'b01;
                mux2 = 2'b00;
                mux3 = 0;
            end else if (d == 2'b01) begin
                mux0 = 0;
                mux1 = 2'b10;
                mux2 = 2'b01;
                mux3 = 0;
            end else if (d == 2'b10) begin
                mux0 = 0;
                mux1 = 2'b00;
                mux2 = 2'b10;
                mux3 = 1;
            end
        end 
    end

    

    always @(*) begin
        case (d)
            2'b00: ad <= num0;
            2'b01: ad <= num1;
            2'b10: ad <= num2;
            2'b11: ad <= num3; 
            default: ad <= num0;
        endcase
    end

    always @(*) begin
        case (d+2'b01)
            2'b00: ad1 <= num0;
            2'b01: ad1 <= num1;
            2'b10: ad1 <= num2;
            2'b11: ad1 <= num3; 
            default: ad1 <= num0;
        endcase
    end
    
    reg rst_c, rst_d;
    always @(posedge clk ) begin
        if(rst_c)
            c <= 2'b00;
        else
            c <= c_mux ? c+1 : c;
    end
    
    always @(posedge clk ) begin
        if(rst_d)
            d <= 2'b00;
        else
            d <= d_mux ? d+1 : d;
    end

    reg a_lt_b;

    always @(*) begin
        a_lt_b = cmp1 < cmp2;
    end

    always@(*) begin
        case(comp_mux)
            2'b00: begin
                cmp1 <= {2'b00,c};
                cmp2 <= 4'd3;
            end 
            2'b01: begin
                cmp1 <= {2'b00,d};
                cmp2 <= 4'd3 - {2'b00,c};
            end 
            2'b10: begin
                cmp1 <= ad1;
                cmp2 <= ad;
            end 
            default: begin
                cmp1 <= ad1;
                cmp2 <= ad;
            end 
        endcase
    end

    // controller
    parameter s0 = 4'd0;
    parameter s1 = 4'd1;
    parameter s2 = 4'd2;
    parameter s3 = 4'd3;
    parameter s4 = 4'd4;
    parameter s5 = 4'd5;
    parameter s6 = 4'd6;
    parameter s7 = 4'd7;
    parameter s8 = 4'd8;


    always @(posedge clk) begin
        if(rst1)
            cs <= s0;
        else
            cs <= ns;
    end

    always @(*) begin
        case (cs)
            s0: begin
                rst <= 0;
                comp_mux <= 2'b00;
                c_mux <= 0;
                d_mux <= 0;
                swap <= 0;
                done <= 0;
                rst_c <= 0;
                rst_d <= 0;
            end 
            s1: begin
                rst <= 1;
                comp_mux <= 2'b00;
                c_mux <= 0;
                d_mux <= 0;
                swap <= 0;
                done <= 0;
                rst_c <= 1;
                rst_d <= 1;
            end
            s2: begin
                rst <= 0;
                comp_mux <= 2'b00;
                c_mux <= 0;
                d_mux <= 0;
                swap <= 0;
                done <= 0;
                rst_c <= 0;
                rst_d <= 0;
            end
            s3: begin
                rst <= 0;
                comp_mux <= 2'b00;
                c_mux <= 0;
                d_mux <= 0;
                swap <= 0;
                done <= 1;
                rst_c <= 0;
                rst_d <= 0;
            end
            s4: begin
                rst <= 0;
                comp_mux <= 2'b01;
                c_mux <= 0;
                d_mux <= 0;
                swap <= 0;
                done <= 0;
                rst_c <= 0;
                rst_d <= 0;
            end
            s5: begin
                rst <= 0;
                comp_mux <= 2'b00;
                c_mux <= 1;
                d_mux <= 0;
                swap <= 0;
                done <= 0;
                rst_c <= 0;
                rst_d <= 1;
            end
            s6: begin
                rst <= 0;
                comp_mux <= 2'b10;
                c_mux <= 0;
                d_mux <= 0;
                swap <= 0;
                done <= 0;
                rst_c <= 0;
                rst_d <= 0;
            end
            s7: begin
                rst <= 0;
                comp_mux <= 2'b00;
                c_mux <= 0;
                d_mux <= 1;
                swap <= 0;
                done <= 0;
                rst_c <= 0;
                rst_d <= 0;
            end
            s8: begin
                rst <= 0;
                comp_mux <= 2'b00;
                c_mux <= 0;
                d_mux <= 0;
                swap <= 1;
                done <= 0;
                rst_c <= 0;
            end
            
            default: begin
                rst <= 0;
                comp_mux <= 2'b00;
                c_mux <= 0;
                d_mux <= 0;
                swap <= 0;
                done <= 0;
                rst_d <= 0;
            end
        endcase
    end

    always @(*) begin
        case (cs)
            s0: ns <= ready ? s1: s0;
            s1: ns <= ready ? s1: s2;
            s2: ns <= a_lt_b ? s4 : s3;
            s3: ns <= s0;
            s4: ns <= a_lt_b ? s6 : s5;
            s5: ns <= s2;
            s6: ns <= a_lt_b ? s8 : s7;
            s7: ns <= s4;
            s8: ns <= s7;
            default: ns <= s0;
        endcase
    end

endmodule