// decoder.sv
// RISC-V Decoder Module
// Ver: 7.0
// Date: 10/02/23
`include "opcodes.sv"

module decoder (
    input logic clock,
    input logic [6:0] opcode, funct7,
    input logic [2:0] funct3,
    output logic [3:0] AluOp,
    output logic regw, ramR, ramW, sext, muldiv,
    output logic [2:0] imm,
    output logic [1:0] writesel, //needs to be 2 bits for the jumps
    output logic [1:0] pcsel
);

always_comb
begin

    //initial values
    AluOp = 4'd0; 
    regw = 1'b0; 
    imm = 3'b0;
    ramR = 1'b0;
    ramW = 1'b0;
    writesel = 2'b00;
    sext = 1'b0;
    pcsel = 2'b00; //increments

    case (opcode)
/////////////////////////////////////////////////////////////////
        //      R Instructions
/////////////////////////////////////////////////////////////////
        `RALU : begin 
                
                regw = 1'b1;

                if(funct7 == 7'd1)
                begin
                        muldiv = 1'b1;
                        writesel = 2'b11;
                end
                else
                begin //all non multiplication extension things
                        AluOp = {funct3, funct7[5]}; //concatenates funct3 and funct7[5] to create AluOp
                        writesel = 2'b00; //write from the ALU
                end

        end
/////////////////////////////////////////////////////////////////
        //      I Instructions - Immediates Only
/////////////////////////////////////////////////////////////////
        `IALU: begin 

                case(funct3)
                        3'b101, 3'b001: begin //srli, srai or slli 
                                AluOp = {funct3, funct7[5]}; 

					if (AluOp == 4'b1010) //used for signed and unsigned
						sext = 1'b0;
					else
						sext = 1'b1;

			        imm = 3'b010; //allows use of 5 bit immediate

                        end
			3'b011: sext = 1'b0; //sltiu 
                        default: begin //this is needed as no other I instructions in the ALU use funct7
                                AluOp = {funct3, 1'b0}; 
			        imm = 3'b001;
				sext = 1'b1;
                        end
                endcase

                regw = 1'b1;
                writesel = 2'b00; //write from the ALU / not completely necessary
        end
/////////////////////////////////////////////////////////////////
        //      I Instructions - Loads Only
/////////////////////////////////////////////////////////////////
        `ILOAD : begin 
            //this needs to be 2 clock cycles
            //fix this somehow

                imm = 3'b001;
                AluOp = 4'b0000; //not completely necessary
                writesel = 2'b01; //write from the RAM
                ramR = 1'b1; 
	        regw = 1'b1;

        end
/////////////////////////////////////////////////////////////////
        //      S Instructions - Store
/////////////////////////////////////////////////////////////////
        `SSTORE : begin 

                imm = 3'b011;
	        AluOp = 4'b0000;
	        writesel = 2'b01; //write from the RAM
	        ramW = 1'b1;	

        end
/////////////////////////////////////////////////////////////////
        //      U Instruction - Load & PC
        //      lui - Load Upper Immediate
        //      auipc - Add Upper Immediate to PC
/////////////////////////////////////////////////////////////////
        `ULOAD, `UPC : begin

		imm = 3'b100;
		AluOp = 4'b0000;
		regw = 1'b1;
        	writesel = 2'b00; //write from the ALU / not completely necessary

        end
/////////////////////////////////////////////////////////////////
        //I Instruction - Jump
        // jalr - Jump & Link Register
/////////////////////////////////////////////////////////////////
        `IJUMP : begin
                pcsel = 2'b01;
                regw = 1'b1;
		writesel = 2'b10;
        end
/////////////////////////////////////////////////////////////////
        //SB Instructions - Branches
/////////////////////////////////////////////////////////////////
        `SBBRANCH : begin

                pcsel = 2'b10;

	end
/////////////////////////////////////////////////////////////////
        //UJ Instruction - Jump
        // jal - Jump & Link 
/////////////////////////////////////////////////////////////////
        `UJJUMP : begin

                pcsel = 2'b11;
		regw = 1'b1;
		writesel = 2'b10;

        end
/////////////////////////////////////////////////////////////////
        default: begin
            $error("opcode error %h", opcode);
        end
    endcase

end

endmodule