// imem.sv
// RISC-V  instruction memory Module
// Ver: 2.0
// Date: 02/02/23

//is this the same as program memory
//The instruction size is 32 bits
//6 bit address
module imem #(parameter n)(
input logic [n-1:0] addr,
output logic [n-1:0] instr
);

logic [n-1:0] iReg [(1<<(n-1))-1:0];

initial //read program file
	$readmemh("prog.hex",iReg);

//assign current instruction
assign instr = iReg[addr];

endmodule