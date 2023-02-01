// cpu.sv
// RISC-V CPU top level Module
// Ver: 2.0
// Date: 31/01/23

module cpu#(parameter n = 32)(
    input logic clock,
    input logic reset,
    output logic [n-1:0] outport //output of cpu - currently this will be ALU output
);

//Inputs and Outputs
/////////////////////////////////////////////////////////////////
//ALU 
logic [3:0] AluOp;
logic imm;
logic [n-1:0] AluB; //ouput from the imm mux
logic shifti;
logic [n-1:0] AluOut;
/////////////////////////////////////////////////////////////////
//Registers
logic [n-1:0] dR1, dR2, wdata;
logic regw;
logic [1:0] writesel;
/////////////////////////////////////////////////////////////////
//Program Counter
logic incr;
/////////////////////////////////////////////////////////////////
//Instruction Memory
parameter ilen = n; //instruction length
parameter alen = 6; //address length

logic [alen-1:0] addr;
logic [ilen-1:0] instr;
/////////////////////////////////////////////////////////////////
//Branch Target Generator
logic brnch;
logic [12:0] brimm; //13 bit branch immediate

 //assign brimm = {instr[31], instr[7], instr[30:25], imm[11:8], 1'b0}; //0 is always at the end, always a multiple of 2
/////////////////////////////////////////////////////////////////
//module instantiations

progc #(.n(n)) programCounter (.clock(clock), .reset(reset),.incr(incr), .brnch(brnch), .brtarg(brimm)
                                         .pcOut(addr));

imem #(.alen(alen), .ilen(ilen)) instructionMem  (.addr(addr), .instr(instr));

registers #(.n(n)) regs (.clock(clock), .regw(regw), .wdata(wdata), 
                         .waddr(instr[11:7]), .rR1(instr[19:15]), .rR2(instr[24:20]), //rd, rs1 and rs2 respectively
                         .dR1(dR1), .dR2(dR2));

alu #(.n(n)) ALUO (.AluOp(AluOp), .A(dR1), .B(AluB),
                   .AluOut(AluOut));

branchgen #(.n(n)) branches (.A(dR1), .B(dR2), .brfunc(instr[14:12]), .brnch(brnch));

//control module
decoder Control (.opcode(instr[6:0]), .funct3(instr[14:12]), .funct7(instr[31:25]), .brnch(brnch), .AluOp(AluOp), .regw(regw),
                 .incr(incr), .imm(imm), .shifti(shifti));

    //MUX for immediate operand
    //This is correct for Iformat except SLLI SRLI and SRAI
    // they only use the first 5 bits of the immediate for the shift 
   //assign AluB = (imm ? instr[31:20] : dR2); //the brackets must contain the bits for the immediate value

   //assign outport = wdata;

   always_comb
   begin
    brimm = {instr[31], instr[7], instr[30:25], imm[11:8], 1'b0}; //0 is always at the end, always a multiple of 2

        if (imm)
        begin 
            
            AluB = (shifti ? instr[24:20] : instr[31:20]); //either shamt or the full imm
        end
        else
        begin

            AluB = dR2; //for the non shift immediate operations
        end
    
    //need to add wb_sel MUX for reg file input
    case(writesel)
        2'b00: begin
            wdata = AluOut;
            //ALU output to reg input
        end
        2'b01: begin
            wdata = pcOut;

            //PC+4 to reg input
            //only for jump
        end
        2'b10: begin
            //wdata = rdataram;

            //RAM to reg input
            //only for load
        end
        default: begin 
        end
    endcase
    outport = wdata;
   end


endmodule