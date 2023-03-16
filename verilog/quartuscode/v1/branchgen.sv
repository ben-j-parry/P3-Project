// branchgen.sv
// RISC-V Branch Signal Generation Module
// 
// Ver: 1
// Date: 10/02/23

module branchgen #(parameter DWIDTH)(
    input logic signed [DWIDTH-1:0] A, B,
    input logic [2:0] brfunc, //funct3
    output logic brnch,
    output logic brnchsext
    );
logic [DWIDTH-1:0] ua, ub;
always_comb
begin
	ua = '0;
	ub = '0;
	
	brnchsext = 1'b0;
    brnch = 1'b0;
    
    case (brfunc)
        3'b000:
        begin
            if (A == B) 
                brnch = 1'b1; //beq
		brnchsext = 1'b1; //potentially not used
        end
        3'b001:
        begin
            if (A != B) 
                brnch = 1'b1; //bne
		brnchsext = 1'b1;
        end
        3'b100: //for both signed and unsigned
        begin
            if (A < B) 
                brnch = 1'b1; //blt
  		brnchsext = 1'b1;
	 end
        3'b101:
        begin
            if (A >= B) 
                brnch = 1'b1; //bge
		brnchsext = 1'b1;
        end
	3'b110: //for both signed and unsigned
        begin
		ua = unsigned'(A);
		ub = unsigned'(B);
            if (A < B) 
                brnch = 1'b1; //bltu
		brnchsext = 1'b0;
        end
 	3'b111:
        begin
		ua = unsigned'(A);
		ub = unsigned'(A);
            if (A >= B) 
                brnch = 1'b1; //bgeu
		brnchsext = 1'b0;
        end
        default: brnch = 1'b0;
    endcase 
end

endmodule
