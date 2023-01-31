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
/////////////////////////////////////////////////////////////////
//Registers
logic [n-1:0] dR1, dR2, wdata;
logic regw;
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

 assign brimm = {instr[31], instr[7], instr[30:25], imm[11:8], 1'b0}; //1 is always at the end, always a multiple of 2
/////////////////////////////////////////////////////////////////
//module instantiations

progc #(.n(n)) programCounter (.clock(clock), .reset(reset),.incr(incr), .brnch(brnch), .brtarg(brimm)
                                         .pcOut(addr));

imem #(.alen(alen), .ilen(ilen)) instructionMem  (.addr(addr), .instr(instr));

registers #(.n(n)) regs (.clock(clock), .regw(regw), .wdata(wdata), 
                         .waddr(instr[11:7]), .rR1(instr[19:15]), .rR2(instr[24:20]), //rd, rs1 and rs2 respectively
                         .dR1(dR1), .dR2(dR2));

alu #(.n(n)) ALUO (.AluOp(AluOp), .A(dR1), .B(AluB),
                   .AluOut(wdata));

//control module
decoder Control (.opcode(instr[6:0]), .funct3(instr[14:12]), .funct7(instr[31:25]), .AluOp(AluOp), .regw(regw),
                 .incr(incr), .imm(imm));

branchgen #(.n(n)) branches (.A(dR1), .B(dR2), .brfunc(instr[14:12]), .brnch(brnch));

    //MUX for immediate operand
    //This is correct for Iformat
   assign AluB = (imm ? instr[31:20] : dR2); //the brackets must contain the bits for the immediate value

   assign outport = wdata;

endmodule