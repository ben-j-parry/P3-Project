// opcodes.sv
// RISC-V Opcodes Module
// Ver: 2.0
// Date: 23/02/23
// includes load from adc 

`define RALU     7'b0110011
`define IALU     7'b0010011 
`define ILOAD    7'b0000011 
`define UPC      7'b0010111	
`define SSTORE   7'b0100011 
`define SBBRANCH 7'b1100011
`define ULOAD    7'b0110111 
`define IJUMP    7'b1100111
`define UJJUMP   7'b1101111
`define ULADC	 7'b1111111 //could potentially add a seperate one for a diff channel?
`define SSDAC	 7'b1111100