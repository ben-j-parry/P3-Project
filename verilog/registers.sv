// registers.sv
// RISC-V registers Module
// Ver: 1.0
// Date: 22/11/22

module registers #(parameter n = 32)(
 input logic clock,
 input logic regw, //write flag,
 input logic [n-1:0] wdata,
 input logic [5:0] waddr,
 input logic [5:0] rR1, rR2,
 output logic [n-1:0] dR1, dR2
); 

logic [n-1:0] regs [31:0]; //32 32-bit registers

always_comb
begin //assigns 
    dR1 = regs[rR1];
    dR2 = regs[rR2];
end

always_ff @ (posedge clock) //handles the writing
begin
    if (regw) //if the write flag is high
        regs[waddr] <= wdata; //writes wdata to register at regaddrW
end


endmodule