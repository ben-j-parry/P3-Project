// alu.sv
// RISC-V ALU Module
// Ver: 1.01
// Date: 22/11/22

module ALU #(parameter n = 32)(
    input logic [3:0] AluOp; //4 bit operation code
    input logic [n-1:0] A,B; //32 bit inputs
    output logic [n-1:0] AluOut; //32 bit outputs
    output logic zflag;
    //what flags are needed??
);

always_comb
begin
    zflag = 1'b0; //default assignments
    AluOut = A;

    case(AluOp) 
    4'd0: AluOut = A + B; //ADD
    4'd1: AluOut = A + (~B + 1); //SUB
    //ALU operations
    //...
    4'd9: AluOut = A | B; //OR
    4'd10: AluOut = A & B; //AND
    
    default: AluOut = 0;
    endcase

    //zflag = AluOut ? 1'b1 : 1'b0;// dont think this is correct
    if(AluOut ==  '0)
        zflag = 1'b1; 
end

endmodule

