// alu.sv
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

logic [n-1:0] reg [31:0]; //32 32-bit registers

always_comb
begin //assigns 
    dR1 = reg[rR1];
    dR2 = reg[rR2];
end

always_ff @ (posedge clk) //handles the writing
begin
    if (regw) //if the write flag is high
        reg[waddr] <= wdata; //writes wdata to register at regaddrW
end


endmodule