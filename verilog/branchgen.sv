// branchgen.sv
// RISC-V Branch Signal Generation Module
// Ver: 1.1
// Date: 28/11/22

module branchgen #(parameter n = 32)(
    input logic [n-1:0] A, B,
    //output logic flags [3:0]
    output logic flags [1:0];
);

always_comb
begin
    flags = {4{1'b0}};

// if A==B is true this can be beq if its false it can be bne
// this can be used for A>=B in the same way
    if (A == B) 
        flag[0] = 1'b1; //beq
    else
        flag[0] = 1'b0; //bne

    if (A >= B)
        flag[1] = 1'b1; //bge
    else
        flag[1] = 1'b0; //ble
  
end
endmodule

/*
    if (A < B)
        flag[2] = 1'b1; //ble
    
    if (A != B)
        flag[3] = 1'b1; //bne
*/