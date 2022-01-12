module csr (
    output reg [31:0] rdata, epc_evec, output reg csr_flag, FlushD1, FlushE1, FlushW,
    input [31:0] addr, operand, Instruction_M, PC_M,
    input clk, rst, interrupt
);

    reg [31:0] csr_register;
    reg [31:0] csr_reg [0:5];
    reg [31:0] mstatus;// mstatus[mie]=mstatus[3]
    reg [31:0] mie;// mie[mite] = mie[7]
    reg [31:0] mip;// mip[mtip] = mip[7]
    reg [31:0] mcause;// mcause[31] = 1 when interrupt by mcause[30:0] = external exception_code = 11
    reg [31:0] mepc;
    reg [31:0] mtvec;
    reg [31:0] igr;
    integer i;

    always @(*) begin
        case (addr)
        32'h300: csr_register = mstatus;
        32'h304: csr_register = mie; 
        32'h305: csr_register = mtvec; 
        32'h344: csr_register = mip; 
        32'h342: csr_register = mcause; 
        32'h341: csr_register = mepc; 
        default: csr_register = igr;
        endcase

        if(mip[7]==1'b1 && mie[7]==1'b1) begin
        FlushD1 = 1;
        FlushE1 = 1;
        FlushW = 1;
        mcause[31] =1'b1;
        mcause[30:0] = 31'd1; 
        mepc = PC_M;
        csr_flag = 1;
        case (mtvec[1:0])
            2'd0: epc_evec = {{2'b0},mtvec[31:2]};
            2'd1: epc_evec = {{2'b0},mtvec[31:2]}+({{1'b0},mcause[30:0]} << 2) ; 
            default: epc_evec = {{2'b0},mtvec[31:2]};
        endcase
        end
    end

    always@(*) begin 
        FlushD1 = 0;
        FlushE1 = 0;
        FlushW = 0;
        csr_flag = 0;
        mcause = 32'b0;
        if (rst) begin
            mip = 0;
            mie = 0;
            mstatus = 0;
            mtvec = 0;
            mepc = 0;
        end 
        else begin
        if(interrupt) begin
            mip[7] = 1;
        end else begin
        mip[7] = 0;
        case ({Instruction_M[6:0],Instruction_M[14:12]})
        10'b1110011_000: begin
            epc_evec = mepc;// mret
            csr_flag = 1;
        end
        10'b1110011_001: begin // csrrw rd,csr,rs1 rd = csr,csr = rs1
            rdata = csr_register;
            case ({{20'b0},Instruction_M[31:20]})
            32'h300: mstatus = operand;
            32'h304: mie = operand; 
            32'h305: mtvec = operand; 
            32'h344: mip = operand; 
            32'h342: mcause = operand; 
            32'h341: mepc = operand; 
            default: igr = operand;
            endcase
        end
        10'b1110011_010: begin // csrrs rd,csr,rs1 rd = csr,csr = csr | rs1
            rdata = csr_register;
            case (addr)
            32'h300: mstatus = csr_register | operand;
            32'h304: mie = csr_register | operand; 
            32'h305: mtvec = csr_register | operand; 
            32'h344: mip = csr_register | operand; 
            32'h342: mcause = csr_register | operand; 
            32'h341: mepc = csr_register | operand; 
            default: igr = csr_register | operand;
            endcase
        end 
        endcase
        end
        end
    end
    
    
endmodule