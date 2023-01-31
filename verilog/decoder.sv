// decoder.sv
// RISC-V Decoder Module
// Ver: 2.0
// Date: 31/01/23
`include "opcodes.sv"

module decoder (
    input logic [6:0] opcode,
    input logic [6:0] funct7,
    input logic [2:0] funct3,
    output logic [3:0] AluOp,
    output logic regw,
    output logic incr,
    output logic imm
);


always_comb
begin
    incr = 1'b1; //increments by default

    AluOp = 4'd0; //initial values
    regw = 1'b0; 
    imm = 1'b0;

 //   opcode = instr[6:0]; //opcode is the first 7 bits of the instr

    case (opcode)
        //      R Instructions
/////////////////////////////////////////////////////////////////
        `RALU : begin 

        AluOp = {funct3, funct7[5]}; //concatenates funct3 and funct7[5] to create AluOp
        regw = 1'b1;

        end
        //      I Instructions - Immediates Only
/////////////////////////////////////////////////////////////////
        `IALU: begin 

        if (funct3 == 3'b101) //srli or srai 
            AluOp = {funct3, funct7[5]};
        else //the rest of the ALU operations
            AluOp = {funct3, 1'b0};
            imm = 1'b1;
            regw = 1'b1;
        end
        //      I Instructions - Loads Only
        //      LOAD And STORE are not included in V1
/////////////////////////////////////////////////////////////////
        `ILOAD : begin 
            //this needs to be 2 clock cycles
        end
        //      S Instructions - Store
/////////////////////////////////////////////////////////////////
        `SSTORE : begin 
        
        end
        //     SB Instructions - Branches
/////////////////////////////////////////////////////////////////
        `SBBRANCH: begin
            //branch gen will be based on the funct 3 
            
        end
/////////////////////////////////////////////////////////////////
        default: begin
            $error("opcode error %h", opcode);
        end
    endcase


end
endmodule
