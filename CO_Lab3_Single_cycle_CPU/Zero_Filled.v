module Zero_Filled (
    data_i,
    data_o
);

  //I/O ports
  input [16-1:0] data_i;
  output [32-1:0] data_o;

  //Internal Signals
  reg [32-1:0] data_o;

  //Zero_Filled
  /*your code here*/

	//genvar i;
	//generate 
	//	for (i = 0; i < 32; i = i + 1) begin : gen_zero
	//		if (i < 16) 
	//			assign data_o[i] = data_i[i];
				
	//		else 
	//			assign data_o[i] = 1'b0;
				
	//		end
	//endgenerate
	
	always @(*) begin
		data_o[15:0] <= data_i[15:0];
		data_o[31:16] <= 16'b0;
	end

endmodule
