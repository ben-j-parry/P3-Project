// imem.sv
// RISC-V  instruction memory Module
// Ver: 1.0
// Date: 28/11/22

//is this the same as program memory
//The instruction size is 32 bits
//6 bit address
module imem #(parameter DWIDTH)(
input logic [31:0] addr,
output logic [DWIDTH-1:0] instr
);

logic [DWIDTH-1:0] iReg [(1<<(5))-1:0];

initial //read program file
	$readmemh("ladc.hex",iReg);

//assign current instruction
assign instr = iReg[addr];

endmodule