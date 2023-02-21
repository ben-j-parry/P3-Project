//muldiv.sv
//RISC-V Multiplication Extension Module
//Ver: 1.0
//21/02/23


//SIGNS ARENT QUITE RIGHT
module muldiv #(parameter DWIDTH) (
    input logic signed [DWIDTH-1:0] A, B, //32 bit inputs
    input logic [2:0] MDFunc,
    output logic [DWIDTH-1:0] MDOut //32 bit outputs
);

logic [DWIDTH-1:0] dividend, divisor, quotient, remain, ua, ub, udiv, udivsr;
logic [63:0] prod;

always_comb 
begin

    dividend = A;
    divisor = B;
    quotient = 0;
    remain = 0;


    case (MDFunc)
        3'b000: //MUL
        begin

            mul (prod, A, B);

            MDOut =  prod[31:0]; 
        end
        3'b001: //MULH
        begin

            mul (prod, A, B);

            MDOut =  prod[63:32]; 
        end
        3'b010: //MULSU
        begin
            
            ub = unsigned'(B);

            mul (prod, A, ub);

            MDOut =  prod[63:32]; 
        end
        3'b011: //MULU
        begin
            
            ua = unsigned'(A);
            ub = unsigned'(B);

            mul (prod, ua, ub);

            MDOut =  prod[63:32]; 
        end
        3'b100: //DIV
        begin
            div (quotient, remain, dividend, divisor);

            MDOut = quotient;
        end
        3'b101: //DIVU
        begin
             udiv = unsigned'(dividend);
            udivsr = unsigned'(udivsr);
            
             div (quotient, remain, udiv, udivsr);

            MDOut = quotient;
        end
        3'b110: //REM
        begin
            div (quotient, remain, dividend, divisor);

            MDOut = remain;
        end
        3'b111: //REMU
        begin
            udiv = unsigned'(dividend);
            udivsr = unsigned'(udivsr);

             div (quotient, remain, udiv, udivsr);

            MDOut = remain;

        end
    endcase

end

task div (output logic quotient, remainer, input logic dividend, divisor);
    begin

        if (divisor != 0) // avoid divide by zero
        begin
            // perform long division
            for (int i = 31; i >= 0; i--)
            begin
                remain = remain << 1;
                remain[0] = dividend[i];
                quotient = quotient << 1;
                    if (remain >= divisor)
                    begin
                        remain = remain - divisor;
                        quotient[0] = 1;
                    end
            end
        end

    end
endtask

task mul (output logic prod, input logic A, B);
    begin
        prod = A * B;
    end
endtask

    
endmodule