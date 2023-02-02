// progc.sv
// RISC-V  Program Counter Module
// Ver: 2.0
// Date: 31/01/23

//v1 of the program counter will only be able to incr
//v2 - branch
//v3 - jump jal
//v4 - jump and link register jalr

//pc is 1 32 bit wide register according to risc-v spec

module progc #(parameter n)(
    input logic clock, reset, //incr, brnch, //brnch, jmp, jmplr
    input logic [1:0] pcsel,
    input logic [12:0] brtarg, //branch target
    input logic [20:0] jmptarg,
    output logic [n-1:0] pcOut,
);

logic [n-1:0] nextval;
always_comb
begin
    case (pcsel)
        2'b00: begin //incr
        nextval = 32'd1;
        //next val = pc + 1
        end
        2'b01: begin //branch
        nextval = brtarg;
        //next val = pc + branch target
        end
        2'b10: begin //jump
        nextval = jmptarg;
        //next val = pc + imm*2
        end
        2'b11: begin //jump r
        //output of ALU
        //next val = rs1 + imm*2
        end
        default:
    endcase
end

always_ff @(posedge clock or posedge reset) 
begin

    if (reset)
        pcOut <= {n{1'b0}}; //reset the counter
    else
        pcOut <= pcOut + nextval;
        //else if (incr) // increment the pc
    //    pcOut <= pcOut + {(n-1){1,b0}, 1'b1}; //parameterised
	    //pcOut <= pcOut + 6'b000001;
    //else if (brnch)
    //    pcOut<= pcOut + brtarg;
    //else if (brnch && incr)
        //pcOut<= pcOut + brtarg;
        //if this doesnt work switch the order of incr and brnch
end

//need to turn off incr if brnch is 1

endmodule