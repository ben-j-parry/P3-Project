module div32 //rd = rs1 /rs2
(
  input logic [31:0] dividend, //rs1
  input logic [31:0] divisor, //rs2
  output logic [31:0] quotient,
  output logic [31:0] remainder
);

  //divsion
  //rd = rs1 / rs2

  //remainder
  //rd = rs1 % rs2

  
  logic [31:0] dividend_reg;
  logic [31:0] divisor_reg;
  logic [31:0] quotient_reg;
  logic [31:0] remainder_reg;

  always_comb
  begin
    dividend_reg = dividend;
    divisor_reg = divisor;
    quotient_reg = 0;
    remainder_reg = 0;

    if (divisor_reg != 0) // avoid divide by zero
    begin
      // perform long division
      for (int i = 31; i >= 0; i--)
      begin
        remainder_reg = remainder_reg << 1;
        remainder_reg[0] = dividend_reg[i];
        quotient_reg = quotient_reg << 1;
        if (remainder_reg >= divisor_reg)
        begin
          remainder_reg = remainder_reg - divisor_reg;
          quotient_reg[0] = 1;
        end
      end
    end
  end

  assign quotient = quotient_reg;
  assign remainder = remainder_reg;


  endmodule