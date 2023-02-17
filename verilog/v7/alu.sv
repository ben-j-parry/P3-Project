// alu.sv
// RISC-V ALU Module
// Ver: 4.0
// Complete with multipication extention
// Date: 17/02/23

module alu #(parameter n)(
    input logic [4:0] AluOp, //4 bit operation code
    input logic signed [n-1:0] A, B, //32 bit inputs
    output logic [n-1:0] AluOut //32 bit outputs
);

logic [n-1:0] ua, ub;

always_comb
begin
    AluOut = A;

    case(AluOp) 
    5'b00000: AluOut = A + B;           //ADD
    5'b00010: AluOut = A + (~B + 1);    //SUB
    5'b00100: AluOut = A << B;          //SLL  (shifts A left B times)
    //requires signed subtraction
    5'b01000: AluOut = (A < B) ? 1 : 0; //SLT  
    //requires unsigned subtraction
    5'b01100:	
	begin

		ua = unsigned'(A);
		ub = unsigned'(B);

	 	AluOut = (ua < ub) ? 1 : 0; //SLTU
	end
    5'b10000: AluOut = A ^ B;          //XOR
    5'b10100: AluOut = A >> B;         //SRL (shifts A right B times)
    5'b10110: AluOut = A >>> B;        //SRA (shifts A right B times but preserves the sign using sign extension)
    5'b11000: AluOut = A | B;          //OR
    5'b11100: AluOut = A & B;          //AND
    //Multiplication Extension
    5'b00001: AluOut = {A * B}[31:0];  //MUL
    5'b00101: AluOut = {A * B}[63:32]; // MULH MUL High 
    5'b01101: 
    begin

        ub = unsigned'(B);

        AluOut = {A * B}[63:32]; // MULHSU MUL High Signed x Unsigned
    end
    5'b01001: AluOut = // MULHU MUL High Unsigned x Unsigned
    begin
        
        ua = unsigned'(A);
        ub = unsigned'(B);

        AluOut = {A * B}[63:32]; // MULHSU MUL High Signed x Unsigned
    end
    //can division be done with shifter?
    //5'b10001: AluOut = // DIV
    //5'b10101: AluOut = // DIV Unsigned
    //5'b11001: AluOut = // Remainder
    //5'b11101: AluOut = // Remainder Unsigned
        //ALL ALU Operations
    default: AluOut = 0;
    endcase
end

endmodule


