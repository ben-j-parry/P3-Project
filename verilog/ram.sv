// ram.sv
// RISC-V synchronous ram Module
// Ver: 1.0
// Date: 22/11/22

//should this module be using the SDRAM on the fpga?
module ram(#parameter n = 32)(
input logic clock,
input logic ramR, ramW,
input logic [5:0] addr, 
input logic [n-1:0] dataW, 
output logic [n-1:0] dataR
);

logic [n-1:0] mem [512:0]; //2MB of synchrnous RAM

always_ff @(posedge clock) 
begin
    if (ramW) //if memwrite is enabled the data is written to ram
        mem[addr] <= dataW;
    
    if (ramR) //if memread is enabled the data is written from ram
        dataR <= mem[addr];
end
endmodule