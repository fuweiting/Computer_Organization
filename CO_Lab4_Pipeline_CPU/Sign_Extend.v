module Sign_Extend (
    data_i,
    data_o
);

  //I/O ports
  input [16-1:0] data_i;

  output [32-1:0] data_o;

  //Internal Signals
  reg [32-1:0] data_o;

  //Sign extended
  /*your code here*/

	//genvar i;
	//generate 
	//	for (i = 0; i < 32; i = i + 1) begin : gen_sign
	//		if (i < 16)
	//			assign data_o[i] = data_i[i];
	//		else
	//			assign data_o[i] = data_i[15];
	
	//		end
	//endgenerate
	
	always @(*) begin
		data_o[15:0] <= data_i[15:0];
		data_o[16] <= data_i[15];
		data_o[17] <= data_i[15];
		data_o[18] <= data_i[15];
		data_o[19] <= data_i[15];
		data_o[20] <= data_i[15];
		data_o[21] <= data_i[15];
		data_o[22] <= data_i[15];
		data_o[23] <= data_i[15];
		data_o[24] <= data_i[15];
		data_o[25] <= data_i[15];
		data_o[26] <= data_i[15];
		data_o[27] <= data_i[15];
		data_o[28] <= data_i[15];
		data_o[29] <= data_i[15];
		data_o[30] <= data_i[15];
		data_o[31] <= data_i[15];
	end

endmodule
