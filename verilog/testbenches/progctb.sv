
module progctb;
parameter alen = 6;
logic clock, reset, incr;
logic [alen-1:0] pcOut;

progc #(.alen(alen)) pc1 (.clock(clock), .reset(reset), .incr(incr), .pcOut(pcOut));

initial//clock
begin
  clock =  0;
  #5ns  
  forever #5ns clock = ~clock;
end

initial
begin	
	reset = 1'b1;
	#15ns
	reset = 1'b0;
	incr = 1'b1;
	
	#200ns
	
	incr = 1'b0;
	
end



endmodule
