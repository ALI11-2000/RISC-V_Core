module csr (
    output reg [31:0] rdata, epc_evec, output reg csr_flag, FlushD1, FlushE1, FlushW,
    input [31:0] addr, operand, Instruction_M, PC_M,
    input clk, rst, interrupt
);

    reg [31:0] csr_reg [0:5];
    reg [31:0] mstatus;// mstatus[mie]=mstatus[3]
    reg [31:0] mie;// mie[mite] = mie[7]
    reg [31:0] mip;// mip[mtip] = mip[7]
    reg [31:0] mcause;// mcause[31] = 1 when interrupt by mcause[30:0] = external exception_code = 11
    reg [31:0] mepc;
    reg [31:0] mtvec;
    integer i;

    always @(*) begin
        mstatus = csr_reg[1];
        mie = csr_reg[2];
        mip = csr_reg[3];
        mcause = csr_reg[4];
        mepc = csr_reg[5];
        mtvec = csr_reg[0];
    end

    always@(*) begin 
        FlushD1 = 0;
        FlushE1 = 0;
        FlushW = 0;
        csr_flag = 0;
        csr_reg[4][31] =1'b0;
        csr_reg[4][30:0] = 31'd0;
        if (rst) begin
            for (i =0 ;i<=5 ;i++ ) begin
                csr_reg[i] <= 0;
            end
        end 
        else begin
        if(interrupt) begin
            FlushD1 = 1;
            FlushE1 = 1;
            FlushW = 1;
            csr_reg[4][31] =1'b1;
            csr_reg[4][30:0] = 31'd1; 
            csr_reg[5] = PC_M;
            epc_evec = mtvec+(mcause[30:0] << 2) ;
            csr_flag = 1;
        end else begin
        case ({Instruction_M[6:0],Instruction_M[14:12]})
        10'b1110011_000: begin
            epc_evec = mepc;// mret
            csr_flag = 1;
        end
        10'b1110011_001: begin // csrrw rd,csr,rs1 rd = csr,csr = rs1
            rdata = csr_reg[addr];
            csr_reg[addr] = operand;
        end
        10'b1110011_010: begin // csrrs rd,csr,rs1 rd = csr,csr = csr | rs1
            rdata = csr_reg[addr];
            csr_reg[addr] = csr_reg[addr] | operand;
        end 
    endcase
        end
        end
    end
    
    
endmodule