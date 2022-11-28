// alu.sv
// RISC-V registers Module
// Ver: 1.0
// Date: 22/11/22

module registers #(parameter n = 32)(
 input logic clock,
 input logic regw, //write flag,
 input logic [n-1:0] wdata,
 input logic [5:0] regaddrW,
 input logic [5:0] regaddrR1, regaddrR2,
 output logic [n-1:0] regdataR1, regdataR2
); 

logic [n-1:0] reg [31:0]; //32 32-bit registers

always_comb
begin //assigns 
    regdataR1 = reg[regaddrR1];
    regdataR2 = reg[regaddrR2];
end

always_ff @ (posedge clk) //handles the writing
begin
    if (regw) //if the write flag is high
        reg[regaddrW] <= wdata; //writes wdata to register at regaddrW
end


endmodule