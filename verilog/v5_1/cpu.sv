// cpu.sv
// RISC-V CPU top level Module
// Ver: 5.0
// Date: 09/02/23

module cpu #(parameter n = 32) (
    input logic clock,
    input logic reset,
    output logic [n-1:0] outport //output of cpu - currently this will be ALU output
);

//Inputs and Outputs
/////////////////////////////////////////////////////////////////
//ALU 
logic [3:0] AluOp;
logic [2:0] imm;
logic [n-1:0] AluA;
logic [n-1:0] AluB; //ouput from the imm mux
logic [n-1:0] AluOutput;
/////////////////////////////////////////////////////////////////
//Registers
logic [31:0] dR1, dR2, regwdata;
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
//wdata is from rs2 of regs (dr2)
//wdata is probs wrong, will sort it when do store
//control module
decoder Control (.clock(clock), .opcode(instr[6:0]), .funct3(instr[14:12]), .funct7(instr[31:25]), .AluOp(AluOp), .regw(regw),
                 .incr(incr), .imm(imm), .writesel(writesel), .ramR(ramR), .ramW(ramW));

 /////////////////////////////////////////////////////////////////
 // Combinational Logic   

    always_comb
    begin
        //calculates the branch target for SB branches
        //brimm = {instr[31], instr[7], instr[30:25], imm[11:8], 1'b0}; //0 is always at the end, always a multiple of 2

	//AluA Mux
	case(ramR || ramW)
	   1'b0: AluA = dR1;
	   1'b1: AluA = instr[19:15];
	   default: AluA = dR1;
	endcase
	
	if (instr[6:0] == 7'b0110111)
		AluA = 5'b0;
	else if (instr[6:0] == 7'b0010111)
		AluA = addr;

	//AluB Mux
	//for branches and jumps might need to make imm 3 bits
	case(imm)
		3'b000: AluB = dR2; //no imm
		3'b001: AluB = instr[31:20]; // I Type Immediate
		3'b010: AluB = instr[24:20]; // I Type Shift Immediate
		3'b011: AluB = {instr[31:25], instr[11:7]}; //S Type Immediate
		3'b100: AluB = {instr[31:12], 12'b0}; // U Type Immediate
		default: AluB = dR2;
	endcase

    case (writesel)
		1'b0: regwdata = AluOutput; //write to regs from alu output
		1'b1: begin //write to regs from ram output
					//used for loads and stores

            //funct3 Load Mux
			//chooses which load is required
	    	if(ramR) begin
				case(instr[14:12]) 
			     	//sign extended
					3'b000: regwdata = {{24{ramROut[7]}}, ramROut[7:0]};   		//lb - Load Byte
					3'b001: regwdata = {{16{ramROut[15]}}, ramROut[15:0]};     	//lh -  Load Halfword
					3'b010: regwdata = ramROut; 								//lw - Load Word
					//not sign extended
					3'b100: regwdata = {24'b0, ramROut[7:0]};	 				//lbu -  Load Byte Unsigned
					3'b101: regwdata = {16'b0, ramROut[15:0]};					//lhu - Load Halfword Unsigned
					default: regwdata = ramROut;
				endcase
			end

			//funct3 Store Mux
			//chooses which store is required
			if (ramW) begin
				case (instr[14:12])
					3'b000: ramWdata = dR2[7:0]; 	//sb - Store Byte
					3'b001: ramWdata = dR2[15:0];	//sh - Store Halfword
					3'b010: ramWdata = dR2;			//sw - Store Word
					default: ramWdata = dR2;
				endcase
			end
			end
			default: regwdata = AluOutput; 
    endcase

	outport = AluOutput;

    end

endmodule