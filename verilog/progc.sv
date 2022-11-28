// progc.sv
// RISC-V  Program Counter Module
// Ver: 1.0
// Date: 25/11/22

//i have chosen 7 as this is the width of the opcode
//not sure where else this comes from
module progc #(parameter instrn = 7)(
    input logic clock, reset, incr, brnch, jmp,
    input logic [instrn-1:0] Branchaddr,
 output logic [instrn-1:0]PCout
);

logic[instrn-1:0] rbranch;

always_comb
begin
    if(incr)
        rbranch = { {(instrn-1){1'b0}}, 3'b4};
    else
        rbranch = Branchaddr;
end

always_ff @(posedge clock or posedge reset) 
begin
    if (reset)
        PCout <= {instrn{1'b0}}
    else if (incr | brnch) // increment or relative branch
        PCout <= instrn + Rbranch; // 1 adder does both
   // else if (PCabsbranch) // absolute branch
       // instrn <= Branchaddr;
        //whats difference between absolute and relative branch
        //this needs to be changed for RISC-V
end