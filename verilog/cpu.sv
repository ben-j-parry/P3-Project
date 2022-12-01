// cpu.sv
// RISC-V CPU top level Module
// Ver: 1.0
// Date: 30/11/22

module cpu#(parameter n = 32)(
    input logic clock,
    input logic reset,
    output logic [n-1:0] outport //output of cpu - currently this will be ALU output
)

//Inputs and Outputs
//ALU 
logic [3:0] AluOp;
logic imm;
logic [n-1:0] ALUimm; //ALU input mux

//Registers
logic [n-1:0] regdataR1, regdataR2, wdata;
logic regw;

//Program Counter
parameter nInstr = 7;
logic clock, reset, incr;
logic [instrn-1:0] progcOut;

//Instruction Memory
parameter ilen = n;
logic [instrn-1:0] addr;
logic [ilen:0] instr;

//module instantiations

progc #(.nInstr(nInstr)) programCounter (.clock(clock), .reset(reset),.incr(incr),
                                         .progcOut(addr));

imem #(.instrn(nInstr), .ilen(ilen)) instructionMem  (.addr(addr), .instr(instr));

registers #(.n(n)) regs (.clock(clock), .regw(regw), .wdata(wdata), 
                         .regaddrW(),.regaddrR1(), .regaddrR2(), //this must be populated with the correct bits of instr
                         .regdataR1(regdataR1), .regdataR2(regdataR2));

alu #(.n(n)) ALUO (.AluOp(AluOp), .A(regdataR1), .B(regdataR2),
                   .AluOut(wdata));

//control module
decoder Control (.instr[I], .AluOp(AluOp), .regw(regw),
                 .incr(incr), .imm(imm));

always_comb 
begin
    //MUX for immediate operand
    ALUimm = (imm ? instr[31:12] : regdataR2); //the brackets must contain the bits for the immediate value

    outport = wdata;

end

endmodule