// progc.sv
// RISC-V  Program Counter Module
// Ver: 2.0
// Date: 9/02/23

//v1 of the program counter will only be able to incr
//v3 - branch
//v4 - jump jal
//v5 - jump and link register jalr

//i have chosen 7 as this is the width of the opcode
//not sure where else this comes from

module progc #(parameter n)(
    input logic clock, reset,
    input logic [1:0] pcsel,
    input logic [n-1:0] targaddr,
    output logic [n-1:0] pcOut,
    output logic [n-1:0] pcplus4
);

logic [n-1:0] tmptrgt;
always_comb
begin
	//pcplus4 ='x; i like but is it useful

	case(pcsel)
	2'b00: tmptrgt = pcOut + 1'b1; //PC + 4
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

always_ff @(posedge clock or posedge reset) 
begin
   if (reset)
        pcOut <= {n{1'b0}}; //reset the counter
   else 
	pcOut <= tmptrgt;
  
 

end


endmodule


