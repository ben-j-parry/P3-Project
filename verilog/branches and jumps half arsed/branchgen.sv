// branchgen.sv
// RISC-V Branch Signal Generation Module
// 
// Ver: 2.2
// Date: 31/01/23

module branchgen #(parameter n = 32)(
    input logic [n-1:0] A, B,
    input logic [2:0] brfunc;
    output logic brnch //funct3
    ); //maybe take incr in here 

always_comb
begin

    brnch = 1'b0;

    case (brfunc)
   //might need more begin and ends
        3'b000:
        begin
            if (A == B) 
                brnch = 1'b1; //beq
        end
        3'b001:
        begin
            if (A != B) 
                brnch = 1'b1; //bne
        end
        3'b100, 3'b110: //for both signed and unsigned
        begin
            if (A < B) 
                brnch = 1'b1; //blt
        end
        3'b101, 3'b111:
        begin
            if (A >= B) 
                brnch = 1'b1; //bge
        end
        default: brnch = 1'b0;
    endcase 
end

endmodule
