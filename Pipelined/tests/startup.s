j reset
j handler
handler:
xori x12,x12,0xFFFFFFFF
mret
reset:
addi x10,x0,0x80
addi x13,x0,1
nop
nop
nop
nop
nop
csrrw x0,mtvec,x13
csrrw x0,mie,x10
main:
addi x11,x11,1
j main
