module ALU (
    aluSrc1,
    aluSrc2,
    ALU_operation_i,
    result,
    zero,
    overflow
);

  //I/O ports
  input [32-1:0] aluSrc1;
  input [32-1:0] aluSrc2;
  input [4-1:0] ALU_operation_i;

  output [32-1:0] result;
  output zero;
  output overflow;

  //Internal Signals
  reg [32-1:0] result;
  wire zero;
  wire overflow;

  //Main function
  /*your code here*/

	always @(*) begin
		case (ALU_operation_i)
			//add
			4'b0010: result <= aluSrc1 + aluSrc2;
			
			//sub
			4'b0110: result <= aluSrc1 + (~aluSrc2 + 32'b1);
			
			//and
			4'b0000: result <= aluSrc1 & aluSrc2;
			
			//or
			4'b0001: result <= aluSrc1 | aluSrc2;
			
			//nor
			4'b1100: result <= ~(aluSrc1 | aluSrc2);
			
			//slt
			4'b0111: begin
						if (aluSrc1[31] != aluSrc2[31]) begin
							if (aluSrc1[31] > aluSrc2[31]) begin
								result <= 32'b1;
								end 
							else begin
								result <= 32'b0;
								end
							end 
						else begin
							if (aluSrc1 < aluSrc2) begin
								result <= 32'b1;
							end
							else begin
								result <= 32'b0;
							end
						end
					end
			//sllv
			4'b1001: result <= aluSrc2 << aluSrc1;
			
			//slrv
			4'b1010: result <= aluSrc2 >> aluSrc1;
			
			//bnez
			4'b1011: result <= (aluSrc1 != 32'b0)? 1 : 0;
			
			//bgez
			4'b1101: result <= (aluSrc1 >= 32'b0)? 1 : 0;
			
			default: result <= 32'b0;
		
		endcase
	end

	assign zero = (result == 32'b0);
	assign overflow = (aluSrc1[31] == aluSrc2[31] && result[31] != aluSrc1[31]) || (aluSrc1[31] != aluSrc2[31] && result[31] == aluSrc2[31]);

endmodule
