// cpu.sv
// RISC-V CPU top level Module
// Ver: 3.0
// Date: 02/02/23

module cpu #(parameter n = 32) (
    input logic clock,
    input logic reset,
    output logic [n-1:0] outport //output of cpu - currently this will be ALU output
);

//Inputs and Outputs
/////////////////////////////////////////////////////////////////
//ALU 
logic [3:0] AluOp;
logic imm;
logic [n-1:0] AluA;
logic [n-1:0] AluB; //ouput from the imm mux
logic [n-1:0] AluOutput;
/////////////////////////////////////////////////////////////////
//Registers
logic [n-1:0] dR1, dR2, regwdata;
logic regw;
/////////////////////////////////////////////////////////////////
//Program Counter
logic incr;
logic [n-1:0] pcOut;
/////////////////////////////////////////////////////////////////
//Instruction Memory
logic [n-1:0] addr;
logic [n-1:0] instr;
/////////////////////////////////////////////////////////////////
//Program Counter
//logic [12:0] brimm;

/////////////////////////////////////////////////////////////////
//RAM
logic ramR;
logic ramW;
logic writesel;
logic rs1imm;
logic [n-1:0] ramROut;
logic [n-1:0] ramWdata;
/////////////////////////////////////////////////////////////////
//Module Instantiations

progc #(.n(n)) programCounter (.clock(clock), .reset(reset),.incr(incr), .pcOut(addr));
                                         
imem #(.n(n)) instructionMem  (.addr(addr), .instr(instr));

registers #(.n(n)) regs (.clock(clock), .regw(regw), .wdata(regwdata), .waddr(instr[11:7]),
                         .rR1(instr[19:15]), .rR2(instr[24:20]), .dR1(dR1), .dR2(dR2)); //rd, rs1 and rs2 respectively
                         
alu #(.n(n)) ALUO (.AluOp(AluOp), .A(AluA), .B(AluB), .AluOut(AluOutput));
                   
ram #(.n(n)) DataMem (.clock(clock), .ramR(ramR), .ramW(ramW), .addr(AluOutput), .dataW(ramWdata), .dataR(ramROut)); 
//wdata is probs wrong, will sort it when do store
//control module
decoder Control (.clock(clock), .opcode(instr[6:0]), .funct3(instr[14:12]), .funct7(instr[31:25]), .AluOp(AluOp), .regw(regw),
                 .incr(incr), .imm(imm), .writesel(writesel), .ramR(ramR), .shifti(shifti));

 /////////////////////////////////////////////////////////////////
 // Combinational Logic   

    always_comb
    begin
        //calculates the branch target for SB branches
        //brimm = {instr[31], instr[7], instr[30:25], imm[11:8], 1'b0}; //0 is always at the end, always a multiple of 2
	    if (ramR)
	    begin	
		    AluA = instr[19:15];
	    end
	    else
	    begin
		    AluA = dR1;
	    end
        //MUX for immediate operand 
        //immediate shifts use shamt
        if (imm) //if imm is active either use full imm or 5 bit imm depending on if shift is used
        begin 

            if (shifti) begin
                AluB = instr[24:20]; //imm shift format
            end
            else begin
                AluB = instr[31:20]; //regular imm format
            end
        end
        else
        begin

            AluB = dR2; //for the non shift immediate operations
        end
        outport = AluOutput;

        case (writesel)
        1'b0: regwdata = AluOutput; //write to regs from alu output
        1'b1: regwdata = ramROut; //write to regs from ram output
        default: regwdata = AluOutput; 
        endcase

    end

endmodule