# Single Cycle Hardware Implementation
For hardware implementation, block RAM has been configured in place of the instruction memory. We can update the contents of the block RAM without performing synthesis from scratch. In order to update contents of the block RAM we will use **update_mem** command in the Vivado Tcl Console. 

For using the **update_mem** command we are required to use the **XPM_MEMORY** from which we selected the single port RAM.

First we need to create the bit file of the design, then we can update the program in the block ram by just updating the bit file. The **mem** should be in the same folder as the **bit** file to update the memory.

```tcl
cd <to the directory containing bit file>

updatemem -force -debug -bit top_hardware.bit -meminfo top_hardware.mmi -data instruction_mem.mem -proc t1/xpm_memory_spram_inst/xpm_memory_base_inst -out out.bit
```
The updated file will be the **out.bit**.