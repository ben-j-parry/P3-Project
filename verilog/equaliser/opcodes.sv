// opcodes.sv
// RISC-V Opcodes Module
// Ver: 3.0
// Date: 21/03/23
// includes custom instructions 

`define RALU     7'b0110011
`define IALU     7'b0010011 
`define ILOAD    7'b0000011 
`define UPC      7'b0010111	
`define SSTORE   7'b0100011 
`define SBBRANCH 7'b1100011
`define ULOAD    7'b0110111 
`define IJUMP    7'b1100111
`define UJJUMP   7'b1101111
//custom instructions
`define ULADC	 7'b1111111 
`define SSDAC	 7'b1111100
`define ULSW 	 7'b1111110