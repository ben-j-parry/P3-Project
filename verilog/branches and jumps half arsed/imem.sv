// imem.sv
// RISC-V  instruction memory Module
// Ver: 1.0
// Date: 28/11/22

//is this the same as program memory
//The instruction size is 32 bits
//6 bit address
module imem #(parameter alen = 6, ilen = 32)(
input logic [alen-1:0] addr,
output logic [ilen-1:0] instr
);

logic [ilen:0] iReg [(1<<alen)-1:0];

initial
	$readmemh("prog.hex",iReg);

//assign current instruction
assign instr = iReg[addr];

endmodule