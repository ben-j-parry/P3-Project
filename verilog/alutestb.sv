// alutestb.sv
// RISC-V ALU Test Bench Module
// Ver: 1.0
// Date: 23/11/22

module alutestb;

parameter n = 32;
logic [3:0] AluOp; //4 bit operation code
logic [n-1:0] A, B; //32 bit inputs
logic [n-1:0] AluOut; //32 bit outputs
logic zflag;

alu #(.n(n)) alu1 (.AluOp(AluOp),.A(A),.B(B),.AluOut(AluOut),.zflag(zflag));

initial
    begin A = 32'd15; B = 32'd2;
        #10 AluOp = 4'd0; //ADD
        #10 AluOp = 4'd1; //SUB
        #10 AluOp = 4'd9; //OR
        #10 AluOp = 4'd10; //AND
		#10;
    end
//this doesnt include a zflag test just realised
endmodule