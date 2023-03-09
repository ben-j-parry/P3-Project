//muldiv.sv
//RISC-V Multiplication Extension Module
//Ver: 1.0
//21/02/23

//assembly code should be written
//MULH[[S]U] rdh, rs1, rs2
//MUL rdl, rs1, rs2

//signed mul
//with 16 bit audio should potentially only need this one (?)
module signed_mult (
    output logic signed [63:0] prod,
    input logic signed [31:0] A, B
);
    assign prod = A * B;
endmodule

//signed unsigned mul
module signed_unsigned_mult (
    output logic signed [63:0] prod,
    input logic signed [31:0] A,
    input logic [31:0] B
);
    assign prod = A * B;
endmodule

//unsigned mul
module unsigned_mult (
     output logic signed [63:0] prod,
    input logic [31:0] A, B
);
    assign prod = A * B;
endmodule

//encapsulation module
module muldiv #(parameter DWIDTH) (
    output logic [DWIDTH-1:0] MDOut,
    input logic [DWIDTH-1:0] A, B,
    input logic [2:0] MDFunc,
	input logic mulEn
);

logic [63:0] prods, prodsu, produ;

    signed_mult MUL(.prod(prods), .A(A), .B(B));
    unsigned_mult MULHU(.prod(produ), .A(A), .B(B));
    signed_unsigned_mult MULHSU(.prod(prodsu), .A(A), .B(B));

always_comb
begin
if (mulEn)
begin
    case (MDFunc)
        3'b000: //MUL
        begin

            MDOut = prods[31:0];
        end
        3'b001: //MULH
        begin

            MDOut = prods[63:32];
        end
        3'b010: //MULHSU
        begin
                                       
            MDOut = prodsu[63:32];      
        end
        3'b011: //MULHU
        begin

            MDOut = produ[63:32];
        end
        //3'b100: //DIV
        //3'b101: //DIVU
        //3'b110: //REM
       // 3'b111: //REMU
       default: MDOut = 0;
    endcase
end
end

endmodule