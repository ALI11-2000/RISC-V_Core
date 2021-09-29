module top (
    output reg [6:0] seg, output reg [7:0] ano ,
    input [3:0] num , input [1:0] sel1,input clk,rst, write,order,ready
);
    reg en0, en1, en2, en3;
    reg [3:0] no1, no2, no3, no0, out;
    wire [3:0] num0, num1, num2,num3;
    
    always @ (*) begin
        if(write == 0)
            {en0,en1,en2,en3} <= 4'b0000;
        else begin
            case(sel1)
                2'b00:{en0,en1,en2,en3} <= 4'b1000;
                2'b01:{en0,en1,en2,en3} <= 4'b0100;
                2'b10:{en0,en1,en2,en3} <= 4'b0010;
                2'b11:{en0,en1,en2,en3} <= 4'b0001;
            default:{en0,en1,en2,en3} <= 4'b0000;
            endcase
        end
    end
    
    always @ (posedge clk) begin
        if(rst)
            no1 <= 4'd0;
        else if (en1) begin
            no1 <= num;
        end
    end
    
    always @ (posedge clk) begin
            if(rst)
                no3 <= 4'd0;
            else if (en3) begin
                no3 <= num;
            end
        end
    
    always @ (posedge clk) begin
            if(rst)
                no0 <= 4'd0;
            else if (en0) begin
                no0 <= num;
            end
    end
    
    always @ (posedge clk) begin
            if(rst)
                no2 <= 4'd0;
            else if (en2) begin
                no2 <= num;
            end
    end
    

    wire [3:0] R1, R2, R3;
    // use your module instead of dp_cont
    dp_cont a2(
        .clk(clk), .ready(ready), .rst1(rst),
        .no0(no0), .no1(no1), .no2(no2), .no3(no3),
        .num0(num0), .num1(num1), .num2(num2), .num3(num3),
        .done(done)
    );

    clkdiv a3(.clock_in(clk),.clock_out(new_clk));

    reg [1:0] sel;

    always @(posedge new_clk) begin
        if(rst) begin
            ano[7] <= 0;
            ano[6] <= 1;
            ano[5] <= 1;
            ano[4] <= 1;
            ano[3:0] <= 4'b1111;
        end else begin
            ano[7] <= ano[4]; 
            ano[6] <= ano[7];
            ano[5] <= ano[6];
            ano[4] <= ano[5];
        end
    end

    always @(*) begin
        case (ano[7:4])
            4'b0111: sel = 2'b00;
            4'b1011: sel = 2'b01;
            4'b1101: sel = 2'b10;
            4'b1110: sel = 2'b11;
            default: sel = 2'b10;
        endcase
    end

    reg [3:0] Res;
    always @(*) begin
        ano[3:0] = 4'b1111;
    end
    
    always @(*) begin
        case(out)
        4'b0000: seg = 7'b0000001; // "0"     
        4'b0001: seg = 7'b1001111; // "1" 
        4'b0010: seg = 7'b0010010; // "2" 
        4'b0011: seg = 7'b0000110; // "3" 
        4'b0100: seg = 7'b1001100; // "4" 
        4'b0101: seg = 7'b0100100; // "5" 
        4'b0110: seg = 7'b0100000; // "6" 
        4'b0111: seg = 7'b0001111; // "7" 
        4'b1000: seg = 7'b0000000; // "8"     
        4'b1001: seg = 7'b0000100; // "9"
		4'b1010: seg = 7'b0001000; // "A"     
        4'b1011: seg = 7'b1100000; // "b"     
        4'b1100: seg = 7'b0110001; // "C"     
        4'b1101: seg = 7'b1000010; // "d"     
        4'b1110: seg = 7'b0110000; // "E"     
        4'b1111: seg = 7'b0111000; // "F"     
        default: seg = 7'b0000001; // "0"
        endcase
    end
    
    reg [3:0] ol, ul;
    
    always @ (*) begin
        case(sel)
            2'b00:begin
                ol <= no0; 
                ul <= num0;
            end
            2'b01:begin
                ol <= no1; 
                ul <= num1;
            end
            2'b10:begin
                ol <= no2; 
                ul <= num2;
            end
            2'b11:begin
                ol <= no3; 
                ul <= num3;
            end
        default:begin
                ol <= no1; 
                ul <= num1;
            end
        endcase
    end
    
    always @ (*) begin
        out <= order ? ul : ol;
    end
    
endmodule