// branchgen.sv
// RISC-V Branch Signal Generation Module
// 
// Ver: 2.2
// Date: 31/01/23

module branchgen #(parameter n = 32)(
    input logic [n-1:0] A, B,
    input logic [2:0] brfunc;
    output logic brnch
    );

always_comb
begin

    brnch = 1'b0;

    case (brfunc)
   //might need more begin and ends
        3'b000:
            if (A == B) 
                brnch = 1'b1; //beq
        3'b001:
            if (A != B) 
                brnch = 1'b1; //beq
        3'b100, 3'b110: //for both signed and unsigned
            if (A < B) 
                brnch = 1'b1; //beq
        3'b101, 3'b111:
            if (A >= B) 
                brnch = 1'b1; //beq
        default: brnch = 1'b0;
    endcase 
end
endmodule
