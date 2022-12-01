// progc.sv
// RISC-V  Program Counter Module
// Ver: 1.0
// Date: 28/11/22

//v1 of the program counter will only be able to incr
//v2 - branch
//v3 - jump jal
//v4 - jump and link register jalr

//i have chosen 7 as this is the width of the opcode
//not sure where else this comes from

module progc #(parameter nInstr = 7)(
    input logic clock, reset, incr, //brnch, jmp, jmplr
    //input logic [instrn-1:0] Branchaddr,
    output logic [instrn-1:0] progcOut
);

always_ff @(posedge clock or posedge reset) 
begin
    if (reset)
        progcOut <= {nInstr{1'b0}} //reset the counter
    else if (incr) // increment the pc
        progcOut <= progcOut + 3'b4; //increment adds 4 as this is because a risc-v instruction is 32 bits
end

endmodule