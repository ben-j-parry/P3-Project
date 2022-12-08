// cpu.sv
// RISC-V CPU top level Module
// Ver: 1.1
// Date: 05/12/22

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
parameter alen = 6; //address length
logic incr;
logic [alen-1:0] pcOut;
/////////////////////////////////////////////////////////////////
//Instruction Memory
parameter ilen = n; //instruction length
logic [alen-1:0] addr;
logic [ilen-1:0] instr;
/////////////////////////////////////////////////////////////////

//module instantiations

progc #(.alen(alen)) programCounter (.clock(clock), .reset(reset),.incr(incr),
                                         .pcOut(addr));

imem #(.alen(alen), .ilen(ilen)) instructionMem  (.addr(addr), .instr(instr));

registers #(.n(n)) regs (.clock(clock), .reset(reset), .regw(regw), .wdata(wdata), 
                         .waddr(instr[11:7]), .rR1(instr[19:15]), .rR2(instr[24:20]), //rd, rs1 and rs2 respectively
                         .dR1(dR1), .dR2(dR2));

alu #(.n(n)) ALUO (.AluOp(AluOp), .A(dR1), .B(AluB),
                   .AluOut(wdata));

//control module
decoder Control (.opcode(instr[6:0]), .funct3(instr[14:12]), .funct7(instr[31:25]), .AluOp(AluOp), .regw(regw),
                 .incr(incr), .imm(imm));

    //MUX for immediate operand
    //This is correct for Iformat
   assign AluB = (imm ? instr[31:20] : dR2); //the brackets must contain the bits for the immediate value

   assign outport = wdata;

endmodule