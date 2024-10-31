module Pipe_Reg_IDEX (
  clk_i,
  rst_n,
  data_i,
  data_o
);

  parameter size = 193;

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
		data_o <= 193'b0;
	else	begin
		data_o[4:0] <= data_i[4:0];			//5-bit from Pipe_Reg[15:11] (rd)
		data_o[9:5] <= data_i[9:5];			//5-bit from Pipe_Reg[20:16] (rt)
		data_o[15:10] <= data_i[15:10];		//6-bit from Pipe_Reg[5:0] (funct_i)
		data_o[20:16] <= data_i[20:16];		//5-bit from Pipe_Reg[10:6] (shamt)
		data_o[52:21] <= data_i[52:21];		//32-bit from ZF
		data_o[84:53] <= data_i[84:53];		//32-bit from SE
		data_o[116:85] <= data_i[116:85];	//32-bit from ReadData2
		data_o[148:117] <= data_i[148:117];	//32-bit from ReadData1
		data_o[180:149] <= data_i[180:149];	//32-bit from Pipe_Reg[63:32] (PC+4)
		data_o[181] <= data_i[181];			//1-bit from Decoder (ALUSrc)
		data_o[184:182] <= data_i[184:182];	//3-bit from Decoder (ALUOp)
		data_o[186:185] <= data_i[186:185];	//2-bit from Decoder (BranchType)
		data_o[187] <= data_i[187];			//1-bit from Decoder (RegDst)
		data_o[188] <= data_i[188];			//1-bit from Decoder (MemWrite)
		data_o[189] <= data_i[189];			//1-bit from Decoder (MemRead)
		data_o[190] <= data_i[190];			//1-bit from Decoder (Branch)
		data_o[191] <= data_i[191];			//1-bit from Decoder (MemtoReg)
		data_o[192] <= data_i[192];			//1-bit from Decoder (RegWrite)
		end
	
	end

endmodule
