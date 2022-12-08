// registers.sv
// RISC-V registers Module
// Ver: 1.0
// Date: 22/11/22

module registers #(parameter n = 32)(
 input logic clock,
 //input logic reset,
 input logic regw, //write flag,
 input logic [n-1:0] wdata,
 input logic [4:0] waddr,
 input logic [4:0] rR1, rR2,
 output logic [n-1:0] dR1, dR2
); 

logic [n-1:0] regs [31:0]; //32 32-bit registers

always_comb
begin //assigns 
	if (rR1==5'd0) //set output of regs to 0 if r0 is the address
		dR1 = {n{1'b0}};
	else
    		dR1 = regs[rR1];

	if (rR2==5'd0)
		dR2 = {n{1'b0}};
	else
	       dR2 = regs[rR2];
end

always_ff @ (posedge clock) //handles the writing
begin
    //no reset here
    if (regw) //if the write flag is high
        regs[waddr] <= wdata; //writes wdata to register at regaddrW
end


endmodule