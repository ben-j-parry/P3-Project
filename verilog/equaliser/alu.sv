// alu.sv
// RISC-V ALU Module
// Ver: 3.0
// Complete 
// Date: 10/02/23

module alu #(parameter DWIDTH)(
    input logic [3:0] AluOp, //4 bit operation code
    input logic signed [DWIDTH-1:0] A, B, //32 bit inputs
    output logic [DWIDTH-1:0] AluOut //32 bit outputs
);

logic [DWIDTH-1:0] ua, ub;

always_comb
begin
    AluOut = A;

    case(AluOp) 
    4'b0000: AluOut = A + B;           //ADD
    4'b0001: AluOut = A + (~B + 1);    //SUB
    4'b0010: AluOut = A << B;          //SLL  (shifts A left B times)
    //requires signed subtraction
    4'b0100: AluOut = (A < B) ? 1 : 0; //SLT  
    //requires unsigned subtraction
    4'b0110:	
	begin 
		ua = unsigned'(A);
		ub = unsigned'(B);
	 	AluOut = (A < B) ? 1 : 0; //SLTU
	end
    4'b1000: AluOut = A ^ B;          //XOR
    4'b1010: AluOut = A >> B;         //SRL (shifts A right B times)
    4'b1011: AluOut = A >>> B;        //SRA (shifts A right B times but preserves the sign using sign extension)
    4'b1100: AluOut = A | B;          //OR
    4'b1110: AluOut = A & B;          //AND
    //ALL ALU Operations
    default: AluOut = 0;
    endcase
end

endmodule