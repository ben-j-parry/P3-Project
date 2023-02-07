// ram.sv
// RISC-V synchronous ram Module
//not included in v1 of CPU
// Ver: 2.2
// Date: 1/12/22

//should this module be using the SDRAM on the fpga?
module ram #(parameter n)(
input logic clock,
input logic ramR, ramW,
input logic [31:0] addr,  //17 bit address 
input logic [n-1:0] dataW, 
output logic [n-1:0] dataR
);


//in the load and store iunstructions the ram address is imm[11:0] + rs1 which is 12.011 bits

//the De2 has 2MB of SRAM 

logic [n-1:0] mem [(1<<5)-1:0]; //1<<17 is the same as 2^17

//tests only
always_comb
begin	
 //mem[5] = 32'd15;
 mem[6] = 32'b11110100001001000000;
 //mem[7] = 32'b11111001110001110000000000000000;
end	


always_ff @(posedge clock) 
begin
   // if (ramW) //if memwrite is enabled the data is written to ram
      //  mem[addr] <= dataW;
    
    if (ramR) //if memread is enabled the data is written from ram
       dataR <= mem[addr];
end

endmodule