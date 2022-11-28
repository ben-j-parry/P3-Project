// decoder.sv
// RISC-V Decoder Module
// Ver: 1.0
// Date: 28/11/22

module decoder (
    input logic [31:0] instr,
    output logic [3:0] AluOp,
    output logic regw,
    output logic incr
)

logic [6:0] opcode;
logic [6:0] funct7;
logic [2:0] funct3;

always_comb
begin
    incr = 1'b1; //increments by default

    AluOp = 4'd0; //initial values
    regw = 1'b0; 

    opcode = instr[6:0]; //opcode is the first 7 bits of the instr

    case (opcode)
        7'b0110011 : begin //R instruction
        funct3 = instr[14:12];
        funct7 = instr[31:25];

        AluOp = {funct3, funct7[5]}; //concatenates funct3 and funct7[5] to create AluOp
        regw = 1'b1;
        end
        7'b0000011 : begin //I instruction - loads only
        funct3 = instr[14:12];

        end
        7'b0100011 : begin //S instruction
        funct3 = instr[14:12];
        
        end
        default: begin
            $error("opcode error %h", opcode);
        end
    endcase


end
