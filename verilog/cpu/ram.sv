// ram.sv
// RISC-V synchronous ram Module
// Ver: 2.2
// Date: 1/12/22

//should this module be using the SDRAM on the fpga?
module ram #(parameter DWIDTH)(
input logic clock,
input logic ramR, ramW,
input logic [31:0] addr,  //17 bit address 
input logic [DWIDTH-1:0] dataW, 
output logic [DWIDTH-1:0] dataR
);


//in the load and store iunstructions the ram address is imm[11:0] + rs1 which is 12.011 bits

//the De2 has 2MB of SRAM 

logic [DWIDTH-1:0] mem [(1<<5)-1:0]; //1<<5 is the same as 2^5

always_ff @(posedge clock) 
begin
     if (ramW) //if memwrite is enabled the data is written to ram
        mem[addr] <= dataW;
    
    if (ramR) //if memread is enabled the data is written from ram
       dataR <= mem[addr];
end

endmodule