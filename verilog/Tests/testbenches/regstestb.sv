// regstestb.sv
// RISC-V Registers Test Bench Module
// Ver: 1.0
// Date: 05/12/22

module regstestb;

parameter n = 32;
logic clock;
logic regw;
logic [n-1:0] wdata;
logic [5:0] waddr;
logic [5:0] rR1, rR2;
logic [n-1:0] dR1, dR2;

registers #(.n(n)) r1 (.clock(clock), .regw(regw), .wdata(wdata), 
                       .waddr(waddr), .rR1(rR1), .rR2(rR2), 
                       .dR1(dR1), .dR2(dR2)); 
//module instantiation

initial//clock
begin
  clock =  0;
  #5ns  
  forever #5ns clock = ~clock;
end

initial
begin 

  regw = 1'b1;
  waddr = 5'd28;
  wdata = 32'd10;
  #100ns
  waddr = 5'd29;
  wdata = 32'd5000;
  #100ns
  regw = 1'b0;
  waddr = 5'd28;
  wdata = 32'd502;
 #100ns
 rR1 = 5'd29;
 rR2 = 5'd28;

end
endmodule