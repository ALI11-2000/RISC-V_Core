module BCD (
    input [7:0] binary,
    output reg [3:0] Hundreds, Tens, Ones
);
    integer  i;

    always @(binary) begin
        Hundreds = 4'd0;
        Tens = 4'b0;
        Ones = 4'b0;

        for (i = 7; i>=0 ; i=i-1) begin
            if (Hundreds >=5) begin
                Hundreds = Hundreds +3;
            end
            if (Tens >=5) begin
                Tens = Tens +3;
            end
            if (Ones >=5) begin
                Ones = Ones +3;
            end
            Hundreds = Hundreds << 1;
            Hundreds[0] = Tens[3];

            Tens = Tens << 1;
            Tens[0] = Ones[3];

            Ones  = Ones << 1;
            Ones[0] = binary[i];
        end

    end
    
endmodule