module Pipe_Reg_EXMEM (
  clk_i,
  rst_n,
  data_i,
  data_o
);

  parameter size = 107;

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
		data_o <= 107'b0;
	else	begin
		data_o[4:0] <= data_i[4:0];			//5-bit from mux_write_reg (write reg address)
		data_o[36:5] <= data_i[36:5];		//32-bit from Pipe_Reg_IDEX[116:85] (ReadData2)
		data_o[68:37] <= data_i[68:37];		//32-bit from mux_RDdata_out (ALU/Shifter/ZF result)
		data_o[69] <= data_i[69];			//1-bit from mux_BranchType_out (BranchType)
		data_o[101:70] <= data_i[101:70];	//32-bit from adder_out2 (branch address)
		data_o[102] <= data_i[102];			//1-bit from Pipe_Reg_IDEX[188] (MemWrite)
		data_o[103] <= data_i[103];			//1-bit from Pipe_Reg_IDEX[189] (MemRead)
		data_o[104] <= data_i[104];			//1-bit from Pipe_Reg_IDEX[190] (Branch)
		data_o[105] <= data_i[105];			//1-bit from Pipe_Reg_IDEX[191] (MemtoReg)
		data_o[106] <= data_i[106];			//1-bit from Pipe_Reg_IDEX[192] (RegWrite)
		end
	
  end

endmodule
