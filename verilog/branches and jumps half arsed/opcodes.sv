// opcodes.sv
// RISC-V Opcodes Module
// Ver: 1.0
// Date: 1/12/22

`define RALU     7'b0110011 //In Decoder - Complete
`define IALU     7'b0010011 //In Decoder - Complete
`define ILOAD    7'b0000011 //In Decoder   
`define UPC      7'b0010111
`define SSTORE   7'b0100011 //In Decoder
`define SBBRANCH 7'b1100011 //In Decoder - Complete Untested
`define ULOAD    7'b0110111
`define IJUMP    7'b1100111 //In Decoder
`define UJJUMP   7'b1101111 //In Decoder