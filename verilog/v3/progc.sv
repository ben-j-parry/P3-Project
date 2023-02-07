// progc.sv
// RISC-V  Program Counter Module
// Ver: 1.0
// Date: 28/11/22

//v1 of the program counter will only be able to incr
//v3 - branch
//v4 - jump jal
//v5 - jump and link register jalr

//i have chosen 7 as this is the width of the opcode
//not sure where else this comes from

module progc #(parameter n)(
    input logic clock, reset, incr, //brnch, jmp, jmplr
    //input logic [instrn-1:0] Branchaddr,
    output logic [n-1:0] pcOut
);

always_ff @(posedge clock or posedge reset) 
begin
    if (reset)
        pcOut <= {n{1'b0}}; //reset the counter
    else if (incr) // increment the pc
	    pcOut <= pcOut + 1;

end

endmodule