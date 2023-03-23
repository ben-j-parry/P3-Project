// rom.sv
// RISC-V Read Only Memory Module
// Ver: 1
// Date: 1/12/22

//should this module be using the SDRAM on the fpga?
module rom #(parameter DWIDTH)(
input logic clock,
input logic ramR,
input logic [31:0] addr,  //17 bit address 
output logic [DWIDTH-1:0] dataR
);


//in the load and store iunstructions the ram address is imm[11:0] + rs1 which is 12.011 bits

//the De2 has 2MB of SRAM 

//memory addreses 63-0
logic [DWIDTH-1:0] mem [(1<<6)-1:0]; //1<<5 is the same as 2^5

//load the memory with coefficients from a hex file

initial
 $readmemh("rom_data.hex",mem); 


always_ff @(posedge clock) 
begin

    if (ramR) //if memread is enabled the data is written from ram
       dataR <= mem[addr];

end

endmodule

//need to split the address space.
 