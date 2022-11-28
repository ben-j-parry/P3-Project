// ram.sv
// RISC-V synchronous ram Module
// Ver: 1.2
// Date: 28/11/22

//should this module be using the SDRAM on the fpga?
module ram(#parameter n = 32)(
input logic clock,
input logic ramR, ramW,
input logic [16:0] addr,  //17 bit address 
input logic [n-1:0] dataW, 
output logic [n-1:0] dataR
);

//logic [n-1:0] mem [511999:0]; //2MB of synchronous RAM
//in the load and store iunstructions the ram address is imm[11:0] + rs1 which is 17 bits
//the De2 has 2MB of SRAM 
// however this would take 19 address bits to realise so have can only use 17 which is 131072
//this allows for 524,288 bytes of memory
//logic [n-1:0] mem [131071:0]; //2^17 is 131072
logic [n-1:0] mem [(1<<17)-1:0] //1<<17 is the same as 2^17


always_ff @(posedge clock) 
begin
    if (ramW) //if memwrite is enabled the data is written to ram
        mem[addr] <= dataW;
    
    if (ramR) //if memread is enabled the data is written from ram
        dataR <= mem[addr];
end
endmodule