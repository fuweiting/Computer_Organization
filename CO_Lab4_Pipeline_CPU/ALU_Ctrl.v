module ALU_Ctrl (
    funct_i,
    ALUOp_i,
    ALU_operation_o,
    FURslt_o,
    leftRight_o
);

  //I/O ports
  input [6-1:0] funct_i;
  input [3-1:0] ALUOp_i;

  output [4-1:0] ALU_operation_o;
  output [2-1:0] FURslt_o;
  output leftRight_o;

  //Internal Signals
  reg [4-1:0] ALU_operation_o;
  reg [2-1:0] FURslt_o;
  reg leftRight_o;

  //Main function
  /*your code here*/

	always @(*) begin
		case (ALUOp_i)
			//R_TYPE
			3'b010: begin
				case (funct_i)
				//add
				6'b100011: begin
							ALU_operation_o <= 4'b0010;
							FURslt_o <= 2'b00;
							end
				//sub
				6'b010011: begin
							ALU_operation_o <= 4'b0110;
							FURslt_o <= 2'b00;
							end
				//and
				6'b011111: begin
							ALU_operation_o <= 4'b0000;
							FURslt_o <= 2'b00;
							end
				//or
				6'b101111: begin
							ALU_operation_o <= 4'b0001;
							FURslt_o <= 2'b00;
							end
				//nor
				6'b010000: begin
							ALU_operation_o <= 4'b1100;
							FURslt_o <= 2'b00;
							end
				//slt
				6'b010100: begin
							ALU_operation_o <= 4'b0111;
							FURslt_o <= 2'b00;
							end
				//sll
				6'b010010: begin
							leftRight_o <= 1'b0;	//shift left
							FURslt_o <= 2'b01;
							end
				//srl
				6'b100010: begin
							leftRight_o <= 1'b1;	//shift right
							FURslt_o <= 2'b01;
							end
				//sllv
				6'b011000: begin
							ALU_operation_o <= 4'b1001;
							FURslt_o <= 2'b00;
							end
				//slrv
				6'b101000: begin
							ALU_operation_o <= 4'b1010;
							FURslt_o <= 2'b00;
							end
				
				default: begin
							ALU_operation_o <= 4'b0000;
							FURslt_o <= 2'b00;
							leftRight_o <= 1'b0;
							end
					endcase
				end
				
			//LW, SW, ADDI
			3'b000:	begin
					ALU_operation_o <= 4'b0010;	//add
					FURslt_o <= 2'b00;
					end
			
			//BEQ, BNE
			3'b001: begin
					ALU_operation_o <= 4'b0110;	//sub
					FURslt_o <= 2'b00;
					end
					
			//BLT
			3'b011: begin
					ALU_operation_o <= 4'b0111;	//slt
					FURslt_o <= 2'b00;
					end
			
			//BNEZ			
			3'b100: begin
					ALU_operation_o <= 4'b1011;	
					FURslt_o <= 2'b00;
					end
					
			//BGEZ			
			3'b101: begin
					ALU_operation_o <= 4'b1101;	
					FURslt_o <= 2'b00;
					end
			
			default: begin
					ALU_operation_o <= 4'b0000;
					FURslt_o <= 2'b00;
					leftRight_o <= 1'b0;
					end
			
		endcase
	end

endmodule
