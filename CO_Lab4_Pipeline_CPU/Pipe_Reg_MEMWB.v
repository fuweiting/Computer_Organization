module Pipe_Reg_MEMWB (
  clk_i,
  rst_n,
  data_i,
  data_o
);

  parameter size = 71;

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
		data_o <= 71'b0;
	else	begin
	data_o[4:0] <= data_i[4:0];			//5-bit from Pipe_Reg_EXMEM[4:0] (write reg address)
	data_o[36:5] <= data_i[36:5];		//32-bit from Pipe_Reg_EXMEM[68:37] (write data)
	data_o[68:37] <= data_i[68:37];		//32-bit from MemRead_data
	data_o[69] <= data_i[69];			//1-bit from Pipe_Reg_EXMEM[105] (MemtoReg)
	data_o[70] <= data_i[70];			//1-bit from Pipe_Reg_EXMEM[106] (RegWrite)
	end
	

  end
endmodule
