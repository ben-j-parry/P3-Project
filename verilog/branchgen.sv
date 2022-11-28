// branchgen.sv
// RISC-V Branch Signal Generation Module
// Ver: 1.0
// Date: 24/11/22

module branchgen #(parameter n = 32)(
    input logic [n-1:0] A, B,
    output logic flags [3:0]
);

always_comb
begin
    flags = {4{1'b0}};


    if (A == B) 
        flag[0] = 1'b1; //beq
    
    if (A >= B)
        flag[1] = 1'b1; //bge

    if (A < B)
        flag[2] = 1'b1; //ble
    
    if (A != B)
        flag[3] = 1'b1; //bne
end
endmodule