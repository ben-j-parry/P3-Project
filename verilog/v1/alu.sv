// alu.sv
// RISC-V ALU Module
// Ver: 1.2
// Date: 05/12/22

module alu #(parameter n = 32)(
    input logic [3:0] AluOp, //4 bit operation code
    input logic [n-1:0] A, B, //32 bit inputs
    output logic [n-1:0] AluOut //32 bit outputs
);

always_comb
begin
    AluOut = A;

    case(AluOp) 
    4'b0000: AluOut = A + B; //ADD
    4'b0001: AluOut = A + (~B + 1); //SUB
    //ALU operations
    //...
    4'b1100: AluOut = A | B; //OR
    4'b1110: AluOut = A & B; //AND
    
    default: AluOut = 0;
    endcase

    //flags are handled seperately
end

endmodule


