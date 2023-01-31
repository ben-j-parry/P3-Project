// progc.sv
// RISC-V  Program Counter Module
// Ver: 2.0
// Date: 31/01/23

//v1 of the program counter will only be able to incr
//v2 - branch
//v3 - jump jal
//v4 - jump and link register jalr

//pc is 1 32 bit wide register according to risc-v spec

module progc #(parameter n = 32)(
    input logic clock, reset, incr, brnch, //brnch, jmp, jmplr
    input logic [12:0] brtarg, //branch target
    output logic [alen-1:0] pcOut
);

always_ff @(posedge clock or posedge reset) 
begin
    if (reset)
        pcOut <= {alen{1'b0}}; //reset the counter
    else if (incr) // increment the pc
        pcOut <= pcOut + {(alen-1){1,b0}, 1'b1}; //parameterised
	    //pcOut <= pcOut + 6'b000001;
    else if (brnch)
        pcOut<= pcOut + brtarg;

//must be 000100 as alen is 6. this will change as alen gets bigger
//pcOut <= pcOut + {(alen-3){1'b0}, 3'b100};
        //pcOut <= pcOut + 6'b000100; //increment adds 4 as this is because a risc-v instruction is 32 bits

end

endmodule