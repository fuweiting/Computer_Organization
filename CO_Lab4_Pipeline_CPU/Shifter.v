module Shifter (
    result,
    leftRight,
    shamt,
    sftSrc
);

  //I/O ports
  output [32-1:0] result;

  input leftRight;
  input [5-1:0] shamt;
  input [32-1:0] sftSrc;

  //Internal Signals
  reg [32-1:0] result;

  //Main function
  /*your code here*/
  
	always @(leftRight, shamt, sftSrc) begin
		case (leftRight)
			//sll
			1'b0: result <= (sftSrc << shamt);
			
			//srl
			1'b1: result <= (sftSrc >> shamt);
		endcase
	end


endmodule
