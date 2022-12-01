// decoder.sv
// RISC-V Decoder Module
// Ver: 1.1
// Date: 1/12/22
`include "opcodes.sv"

module decoder (
    input logic [6:0] opcode;
    input logic [6:0] funct7;
    input logic [2:0] funct3;
 //   input logic [31:0] instr, //can replace with the bits for opcode, funct3 and funct7
    output logic [3:0] AluOp,
    output logic regw,
    output logic incr,
    output logic imm
)

        //funct3 = instr[14:12];
        //funct7 = instr[31:25];

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
//      I Instructions - Loads Only
/////////////////////////////////////////////////////////////////
        `ILOAD : begin 
            //this needs to be 2 clock cycles
        end
//      I Instructions - Immediates Only
/////////////////////////////////////////////////////////////////
        `IALU: begin 

        if (funct3 == 3'b101) //srli or srai 
        begin 
            funct7 = instr[31:25];

            AluOp = {funct3, funct7[5]};
        end
        else
        begin //the rest of the ALU operations
            AluOp = {funct3, 1'b0};
        end
        
        imm = 1'b1;
        regw = 1'b1;
        end
//      S Instructions
/////////////////////////////////////////////////////////////////
        `SSTORE : begin 
        
        end
/////////////////////////////////////////////////////////////////
        default: begin
            $error("opcode error %h", opcode);
        end
    endcase


end
