// RISCVtb.sv
// RISC-V CPU Test Bench Module
// Ver: 1.0
// Date: 06/12/22

module cputestb;
parameter DWIDTH = 32;
parameter PCLEN = 32;
logic clock;
logic reset;
logic [DWIDTH-1:0] outport;

cpu #(.DWIDTH(DWIDTH), .PCLEN(PCLEN)) cpu1 (.*);

initial//clock
begin
  clock =  0; 
  forever #5ns clock = ~clock;
end

initial 
begin
//reset the cpu 
reset = 1'b1;

#5ns reset = 1'b0;

end
endmodule
