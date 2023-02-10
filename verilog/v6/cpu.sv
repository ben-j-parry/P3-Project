// cpu.sv
// RISC-V CPU top level Module
// Ver: 6.0
// Date: 09/02/23

module cpu #(parameter n = 32) ( //incorrectly parameterised i think
    input logic clock,
    input logic reset,
    output logic [n-1:0] outport //output of cpu - currently this will be ALU output
);

//Inputs and Outputs
/////////////////////////////////////////////////////////////////
//ALU 
logic [3:0] AluOp;
logic [2:0] imm;
logic [n-1:0] AluA, AluB, AluOutput;
//logic [n-1:0] AluB; //ouput from the imm mux
//logic [n-1:0] AluOutput;
/////////////////////////////////////////////////////////////////
//Registers
logic [31:0] dR1, dR2, regwdata;
logic regw;
/////////////////////////////////////////////////////////////////
//Program Counter
logic [1:0] pcsel;
//logic [12:0] brimm;
logic [n-1:0] targaddr, pcplus4;
//logic [n-1:0] pcplus4;
/////////////////////////////////////////////////////////////////
//Instruction Memory
logic [n-1:0] addr, instr;
//logic [n-1:0] instr;
/////////////////////////////////////////////////////////////////
//RAM
logic ramR, ramW;
//logic ramW;
logic [1:0] writesel;
logic [n-1:0] ramROut, ramWdata;
//logic [n-1:0] ramWdata;
/////////////////////////////////////////////////////////////////
//Module Instantiations

progc #(.n(n)) programCounter (.clock(clock), .reset(reset), .pcsel(pcsel), .targaddr(targaddr), .pcOut(addr), .pcplus4(pcplus4));
                                         
imem #(.n(n)) instructionMem  (.addr(addr), .instr(instr));

registers #(.n(n)) regs (.clock(clock), .regw(regw), .wdata(regwdata), .waddr(instr[11:7]),
                         .rR1(instr[19:15]), .rR2(instr[24:20]), .dR1(dR1), .dR2(dR2)); //rd, rs1 and rs2 respectively
                         
alu #(.n(n)) ALUO (.AluOp(AluOp), .A(AluA), .B(AluB), .AluOut(AluOutput));
                   
ram #(.n(n)) DataMem (.clock(clock), .ramR(ramR), .ramW(ramW), .addr(AluOutput), .dataW(ramWdata), .dataR(ramROut)); 

//Control Module
decoder Control (.clock(clock), .opcode(instr[6:0]), .funct3(instr[14:12]), .funct7(instr[31:25]), .AluOp(AluOp), .regw(regw),
                  .imm(imm), .writesel(writesel), .ramR(ramR), .ramW(ramW), .pcsel(pcsel));

 /////////////////////////////////////////////////////////////////
 // Combinational Logic   

    always_comb
    begin
        //calculates the branch target for SB branches
        //brimm = {instr[31], instr[7], instr[30:25], imm[11:8], 1'b0}; //0 is always at the end, always a multiple of 2
		//jalimm = {instr[31], instr[21:12], instr[22], instr[30:23], 1'b0};//
	
	case(pcsel)
		2'b00: targaddr = 1;//pc + 4
		2'b01: targaddr = dR1 + instr[31:20];//jalr is this allowed
		//2'b10: //branch
		//2'b11: targaddr = {instr[31], instr[21:12], instr[22], instr[30:23], 1'b0};//jal
		2'b11: begin
			targaddr = instr[31:12];
		end
		default: targaddr = 1;
	endcase

	//AluA Mux
	//could this be moved in the writesel case
	case(ramR || ramW)
	   1'b0: AluA = dR1;
	   1'b1: AluA = instr[19:15];
	   default: AluA = dR1;
	endcase
	
	if (instr[6:0] == 7'b0110111) //adds immediate to 0 for lui
		AluA = 5'b0;
	else if (instr[6:0] == 7'b0010111) //adds pcOut to immediate for auipc
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
		2'b00: regwdata = AluOutput; //write to regs from alu output
		2'b01: begin //write to regs from ram output
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
		2'b10: regwdata = pcplus4; //write to regs from pc + 4 
					   //rd is meant to be x1 i think
		default: regwdata = AluOutput; 
    endcase

	outport = AluOutput;

    end

endmodule