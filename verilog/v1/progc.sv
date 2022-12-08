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

module progc #(parameter alen = 6)(
    input logic clock, reset, incr, //brnch, jmp, jmplr
    //input logic [instrn-1:0] Branchaddr,
    output logic [alen-1:0] pcOut
);

always_ff @(posedge clock or posedge reset) 
begin
    if (reset)
        pcOut <= {alen{1'b0}}; //reset the counter
    else if (incr) // increment the pc
//must be 000100 as alen is 6. this will change as alen gets bigger
//pcOut <= pcOut + {(alen-3){1'b0}, 3'b100};
        //pcOut <= pcOut + 6'b000100; //increment adds 4 as this is because a risc-v instruction is 32 bits
	pcOut <= pcOut + 6'b000001;
end

endmodule