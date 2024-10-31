`include "Full_adder.v"
module ALU_1bit (
    a,
    b,
    invertA,
    invertB,
    operation,
    carryIn,
    less,
    result,
    carryOut
);

  //I/O ports
  input a;
  input b;
  input invertA;
  input invertB;
  input [2-1:0] operation;
  input carryIn;
  input less;

  output result;
  output carryOut;
  
  output p, g;
   
  reg result;
  wire AND, OR, ADD;
  wire in1, in2;
  output eq;	
  
  //Internal Signals
  //wire result;
  //wire carryOut;

  //Main function

assign in1 = invertA ^ a;
assign in2 = invertB ^ b;

assign eq = in1 ^ in2;
   
assign OR  = in1 | in2; //P
assign AND = in1 & in2; //G
assign ADD = eq ^ carryIn;
assign carryOut = (in1 & in2) | (in1 & carryIn) | (in2 & carryIn);

assign p = OR;
assign g = AND;
   
always@(*)begin
	case (operation)
	  2'b00 : result = OR;
	  2'b01 : result = AND;
	  2'b10 : result = ADD;
	  2'b11 : result = less;
	endcase
end

		
endmodule
