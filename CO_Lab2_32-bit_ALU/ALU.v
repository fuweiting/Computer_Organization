`include "ALU_1bit.v"
module ALU (
    aluSrc1,
    aluSrc2,
    invertA,
    invertB,
    operation,
    result,
    zero,
    overflow
);

  //I/O ports
  input [32-1:0] aluSrc1;
  input [32-1:0] aluSrc2;
  input invertA;
  input invertB;
  input [2-1:0] operation;


  output [32-1:0] result;
  output zero;
  output overflow;

  //Internal Signals
  wire [32-1:0] result;
  wire zero;
  wire overflow;

  //Main function
  wire set;
  wire [32-1:0] carry;

  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : gen_alu
		if (i == 0)
			ALU_1bit alu1(
				.a(aluSrc1[i]),
				.b(aluSrc2[i]),
				.invertA(invertA),
				.invertB(invertB),
				.operation(operation),
				.carryIn(invertB),
				.less(set),
				.result(result[i]),
				.carryOut(carry[i])
			);
		else
			ALU_1bit alu2(
				.a(aluSrc1[i]),
				.b(aluSrc2[i]),
				.invertA(invertA),
				.invertB(invertB),
				.operation(operation),
				.carryIn(carry[i-1]),
				.less(1'b0),
				.result(result[i]),
				.carryOut(carry[i])
			);
    end
  endgenerate


  assign zero = (result == 0);
  
  //assign overflow = (aluSrc1[31] == aluSrc2[31] && result[31] != aluSrc1[31]) || (aluSrc1[31] != aluSrc2[31] && result[31] == aluSrc2[31]);
  
  assign overflow = carry[31] ^ carry[30];
  
  assign set = (aluSrc1 < aluSrc2)? 1 : 0;

endmodule
