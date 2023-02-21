// muldivtb.sv
// RISC-V Multiplication Test Bench Module
// Ver: 1.0
//21/02/23

module muldivtb;
parameter DWIDTH = 32;
logic signed [DWIDTH-1:0] A, B; //32 bit inputs
logic [2:0] MDFunc;
logic [DWIDTH-1:0] MDOut; //32 bit outputs

muldiv #(.DWIDTH(DWIDTH)) md (.*);

initial
begin
    A = 32'd120;
    B = -32'd24;
    MDFunc = 3'b000;
    #5ns
    MDFunc = 3'b001;
    #5ns
    MDFunc = 3'b010;
    #5ns
    MDFunc = 3'b011;
    #5ns
    MDFunc = 3'b100;
    #5ns
    MDFunc = 3'b101;
    #5ns
    B = 32'd120;
    A = -32'd24;
    #5ns
    MDFunc = 3'b110;
    #5ns
    MDFunc = 3'b111;
end

endmodule