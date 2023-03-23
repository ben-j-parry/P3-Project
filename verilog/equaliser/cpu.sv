// cpu.sv
// RISC-V CPU top level Module
// Ver: 8.0
// Date: 17/02/23

module cpu #(parameter DWIDTH = 32, PCLEN = 32) (
    input logic clock,
    input logic reset,
	input logic [31:0] adcdata, switchdata, //cpu inputs 32 bit audio samples
    output logic [DWIDTH-1:0] outport, //output of cpu, used to output the filtered audio
	output logic output_valid, input_ready	//may need two of each if i make the processor stereo
);

//output_valid is the processor saying the input data to the DAC is valid and will be written to
//input_ready is the processor saying the procesor is ready to take the next input sample

//Inputs and Outputs
/////////////////////////////////////////////////////////////////
//ALU 
logic [3:0] AluOp;
logic [2:0] imm;
logic [DWIDTH-1:0] AluA, AluB, AluOutput;
/////////////////////////////////////////////////////////////////
//Registers
logic [DWIDTH-1:0] dR1, dR2, regwdata;
logic regw;
/////////////////////////////////////////////////////////////////
//Program Counter
logic [1:0] pcsel;
logic signed [31:0] targaddr, pcplus4;
logic brnch;
logic sext, brnchsext;
/////////////////////////////////////////////////////////////////
//Instruction Memory
logic [31:0] addr;
logic [DWIDTH-1:0] instr; //should probs be different parameters
/////////////////////////////////////////////////////////////////
//RAM
logic ramR, ramW;
logic [2:0] writesel;
logic [DWIDTH-1:0] ramROut, ramWdata;
/////////////////////////////////////////////////////////////////


//Extensions
/////////////////////////////////////////////////////////////////
//Multiplication Extension
logic [DWIDTH-1:0] MDOut;
logic [DWIDTH-1:0] MA, MB;
logic mulEn;
/////////////////////////////////////////////////////////////////
//DAC Output
logic outputbool, inputbool;
/////////////////////////////////////////////////////////////////
//ROM
logic [DWIDTH-1:0] romROut;
logic [DWIDTH-1:0] tmp_load;

//Module Instantiations
/////////////////////////////////////////////////////////////////

progc #(.PCLEN(PCLEN)) programCounter (.clock(clock), .reset(reset), .pcsel(pcsel), .targaddr(targaddr), .pcOut(addr), .pcplus4(pcplus4));
                                         
imem #(.DWIDTH(DWIDTH)) instructionMem  (.addr(addr), .instr(instr));

registers #(.DWIDTH(DWIDTH)) regs (.clock(clock), .regw(regw), .wdata(regwdata), .waddr(instr[11:7]),
                         .rR1(instr[19:15]), .rR2(instr[24:20]), .dR1(dR1), .dR2(dR2)); //rd, rs1 and rs2 respectively
                         
alu #(.DWIDTH(DWIDTH)) ALUO (.AluOp(AluOp), .A(AluA), .B(AluB), .AluOut(AluOutput));
                   
ram #(.DWIDTH(DWIDTH)) DataMem (.clock(clock), .ramR(ramR), .ramW(ramW), .addr(AluOutput), .dataW(ramWdata), .dataR(ramROut)); 

branchgen #(.DWIDTH(DWIDTH)) branchcondgen (.A(dR1), .B(dR2), .brfunc(instr[14:12]), .brnch(brnch), .brnchsext(brnchsext));

//Control Module
decoder Control (.clock(clock), .opcode(instr[6:0]), .funct3(instr[14:12]), .funct7(instr[31:25]), .AluOp(AluOp), .regw(regw),
                  .imm(imm), .writesel(writesel), .ramR(ramR), .ramW(ramW), .pcsel(pcsel), .sext(sext), .mulEn(mulEn), .outputbool(outputbool), .inputbool(inputbool));

//Multiplication Extension
muldiv #(.DWIDTH(DWIDTH)) Multiplier (.A(dR1), .B(dR2), .MDFunc(instr[14:12]), .MDOut(MDOut), .mulEn(mulEn));

//ROM

rom #(.DWIDTH(DWIDTH)) CoeffMem (.clock(clock), .ramR(ramR), .addr(AluOutput), .dataR(romROut));

 /////////////////////////////////////////////////////////////////
 
 
 // Combinational Logic  
 ///////////////////////////////////////////////////////////////// 

    always_comb
    begin
	
	targaddr ='0;
	AluA = '0;
	AluB = '0;
	regwdata = '0;
	ramWdata = '0;
	tmp_load = '0;
	
	//pc target generation
	case(pcsel) 
		2'b00: targaddr = 1;//pc + 4
		2'b01: targaddr = dR1 + instr[31:20];//jalr 
		//2'b10: targaddr = {instr[31], instr[7], instr[30:25], imm[11:8], 1'b0};
		2'b10: begin //branch
			if(brnch) //branch target generation
				if (brnchsext)
					targaddr = {{22{instr[31]}}, instr[7], instr[30:25], instr[11:9]}; //0 is always at the end, always a multiple of 2
					//targaddr = ({instr[31], instr[7], instr[30:25], instr[11:8]}>>1); //0 is always at the end, always a multiple of 2
				else
					targaddr = ({instr[31], instr[7], instr[30:25], instr[11:8]}>>1); //looks wrong
//needs to be sign extended	
			else
				targaddr = 1'b1;
		end	
		2'b11: begin
			 targaddr = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};//jal
			targaddr = (targaddr >>>2);
			end
		//2'b11: targaddr = {instr[31:12]};
			//targaddr = {instr[31:12] >> 2};
		default: targaddr = 1;
	endcase

	//AluA Mux
	//could this be moved in the writesel case or combined with the lui auipc if statement
	//dont think its that important

	case({ramR, ramW}) //decides the value of AluA
	   2'b00: AluA = dR1;
	   2'b01, 2'b10: AluA = (instr[19:15]);
	   default: AluA = dR1;
	endcase

	
	case(instr[6:0]) //needed for auipc and lui
		7'b0110111: AluA = 5'b0;
		7'b0010111: AluA = addr;
		default: AluA = dR1;
	endcase

	//AluB Mux
	//for branches and jumps might need to make imm 3 bits
	case(imm)
		3'b000: AluB = dR2; //no imm
		3'b010: begin
			if(sext)
				AluB = {{26{instr[24]}}, instr[24:20]}; // I Type Shift Immediate

			else
				AluB = instr[24:20];
		end
		3'b001: begin
			if(sext)
				AluB = {{20{instr[31]}}, instr[31:20]}; // I Type Immediate

			else
				AluB = instr[31:20];
		end 
		3'b011: AluB = ({instr[31:25], instr[11:7]}); //S Type Immediate
		3'b100: AluB = {instr[31:12], 12'b0}; // U Type Immediate
		default: AluB = dR2;
	endcase

    case (writesel)
		3'b000: regwdata = AluOutput; //write to regs from alu output
		3'b001: 
		begin //write to regs from ram output
			  //used for loads and stores
			  
			AluA = AluA>>2; //shifts the values so that they are no longer addressing bytes
			AluB = AluB>>2;
		
            	//funct3 Load Mux
	    		if(ramR) begin
					
					//AluA = instr[19:15];
					

					//if the memory address is between 0 and 63 the CPU will read from the ROM otherwise it will read from RAM
					if(AluOutput < 32'd64)
					begin
						tmp_load = romROut;
					end
					else
					begin
						tmp_load = ramROut;
					end


					case(instr[14:12]) 		//chooses which load is required
						//sign extended
						3'b000: regwdata = {{24{tmp_load[7]}}, tmp_load[7:0]};   		//lb - Load Byte
						3'b001: regwdata = {{16{tmp_load[15]}}, tmp_load[15:0]};     	//lh -  Load Halfword
						3'b010: regwdata = tmp_load; 								//lw - Load Word
						//not sign extended
						3'b100: regwdata = {24'b0, tmp_load[7:0]};	 				//lbu -  Load Byte Unsigned
						3'b101: regwdata = {16'b0, tmp_load[15:0]};					//lhu - Load Halfword Unsigned
						default: regwdata = tmp_load;
					endcase

				
				end
				else 
				begin

					//AluA = dR1;
					regwdata = AluOutput;
				end

			//funct3 Store Mux
			
			if (ramW) begin
			
				//AluA = instr[19:15];

				case (instr[14:12]) //chooses which store is required
					3'b000: ramWdata = {24'b0, dR2[7:0]}; 	//sb - Store Byte
					3'b001: ramWdata = {16'b0, dR2[15:0]};	//sh - Store Halfword
					3'b010: ramWdata = dR2;			//sw - Store Word
					default: ramWdata = dR2;
				endcase
			end
			else
			begin

				//AluA = dR1;
				ramWdata = 32'b0;
			end
		end
		3'b010: regwdata = pcplus4; //write to regs from pc + 4
					   //rd is meant to be x1 i think
		3'b011: regwdata = MDOut; //space here for the MULDIV output
		3'b100: regwdata = adcdata;
		3'b101: regwdata = switchdata;
		default: regwdata = AluOutput; 
    endcase
	end
 /////////////////////////////////////////////////////////////////
 
 
 //Assignments
 /////////////////////////////////////////////////////////////////
	assign outport = outputbool ? dR1 : 32'd0;
	assign output_valid = outputbool;
	assign input_ready =  inputbool;
/////////////////////////////////////////////////////////////////


endmodule