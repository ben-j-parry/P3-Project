// alutestb.sv
// RISC-V CPU v1 Test Bench Module
// Ver: 2.0
// Date: 02/02/23

module cputestb;
parameter n = 32;
logic clock;
logic reset;
logic [n-1:0] outport;

cpu #(.n(n)) cpu1 (.clock(clock), .reset(reset), .outport(outport));

initial//clock
begin
  clock =  0;
  #5ns  
  forever #5ns clock = ~clock;
end

initial 
begin
//reset the cpu 
reset = 1'b1;

#20ns reset = 1'b0;

end
endmodule
