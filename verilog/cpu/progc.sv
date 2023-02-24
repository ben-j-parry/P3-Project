// progc.sv
// RISC-V  Program Counter Module
// Ver: 3.0
// Date: 10/02/23

module progc #(parameter PCLEN) (
    input logic clock, reset,
    input logic [1:0] pcsel,
    input logic [PCLEN-1:0] targaddr,
    output logic [PCLEN-1:0] pcOut,
    output logic [PCLEN-1:0] pcplus4
);

logic [PCLEN-1:0] tmptrgt;

always_comb
begin

	case(pcsel)
	2'b00: tmptrgt = pcOut + 1'b1; //PC + 4
	2'b10: tmptrgt = pcOut + targaddr; //Branches
	2'b01: begin //JALR
		tmptrgt = targaddr;
		pcplus4 = pcOut + 1; 
	end
	2'b11: begin  //JAL
		tmptrgt = pcOut + targaddr;
		pcplus4 = pcOut + 1;
	end
	default: $error("error");
	endcase
	
end

//first stage of pipeline
always_ff @(posedge clock or posedge reset) 
begin
   if (reset)
        pcOut <= {PCLEN{1'b0}}; //reset the counter
   else 
	pcOut <= tmptrgt;
  
 

end


endmodule


