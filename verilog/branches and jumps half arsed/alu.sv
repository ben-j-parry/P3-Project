// alu.sv
// RISC-V ALU Module
// Ver: 2.0
// Complete untested
// Date: 31/01/23

module alu #(parameter n = 32)(
    input logic [3:0] AluOp, //4 bit operation code
    input logic [n-1:0] A, B, //32 bit inputs
    output logic [n-1:0] AluOut //32 bit outputs
);

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
    4'b0110: AluOut = (A < B) ? 1 : 0; //SLTU
    4'b1000: AluOut = A ^ B;          //XOR
    4'b1010: AluOut = A >> B;         //SRL (shifts A right B times)
    4'b1011: AluOut = A >>> B;        //SRA (shifts A right B times but preserves the sign using sign extension)
    4'b1100: AluOut = A | B;          //OR
    4'b1110: AluOut = A & B;          //AND
    //ALL ALU Operations
    default: AluOut = 0;
    endcase

    //flags are handled seperately
end

endmodule


