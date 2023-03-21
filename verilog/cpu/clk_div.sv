 module clk_div(
				input reg clk,
				input reg reset,
				output reg clk_out
 );
 
 reg [3:0] counter;
 
 always_ff @(posedge clk)
 begin
	if (reset)
	begin	
		clk_out <= '0;
		counter <= '0;
	end
	else if (counter == 15)
	begin
		counter <= '0;
		clk_out <= ~clk_out;
	end
	else
		counter <= counter + 4'b01;
 end

endmodule