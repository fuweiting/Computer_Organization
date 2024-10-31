module Pipe_Reg_IFID (
  clk_i,
  rst_n,
  data_i,
  data_o
);

  parameter size = 64;

  //I/O ports
  input clk_i;
  input rst_n;
  input [size-1:0] data_i;

  output [size-1:0] data_o;

  //Internal Signals
  reg [size-1:0] data_o;

  //Main function
  /*your code here*/
  
  always @(posedge clk_i) begin
  
	if(~rst_n)
		data_o <= 64'b0;
	else	begin
		data_o[31:0] <= data_i[31:0];	//from instr_o
		data_o[63:32] <= data_i[63:32];	//from adder_out1 (PC+4)
		end

	end

endmodule
