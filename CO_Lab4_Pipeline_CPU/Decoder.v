module Decoder (
    instr_op_i,
    RegWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RegDst_o,
    Jump_o,
    Branch_o,
    BranchType_o,
    MemRead_o,
    MemWrite_o,
    MemtoReg_o
);

  //I/O ports
  input [6-1:0] instr_op_i;

  output RegWrite_o;
  output [3-1:0] ALUOp_o;
  output ALUSrc_o;
  output RegDst_o;
  output Jump_o;
  output Branch_o;
  output [2-1:0]BranchType_o;
  output MemRead_o;
  output MemWrite_o;
  output MemtoReg_o;

  //Internal Signals
  reg RegWrite_o;
  reg [3-1:0] ALUOp_o;
  reg ALUSrc_o;
  reg RegDst_o;
  reg Jump_o;
  reg Branch_o;
  reg [2-1:0]BranchType_o;
  reg MemRead_o;
  reg MemWrite_o;
  reg MemtoReg_o;
  
  reg [32-1:0] pc_out_o;
  
  //Main function
  /*your code here*/

	always @(*) begin
		case (instr_op_i)
			//OP_R_TYPE
			6'b000000:
			begin
				RegWrite_o <= 1'b1;
				ALUOp_o <= 3'b010;
				ALUSrc_o <= 1'b0;
				RegDst_o <= 1'b1;
				Jump_o <= 1'b0;
				Branch_o <= 1'b0;
				BranchType_o <= 2'b00;
				MemRead_o <= 1'b0;
				MemWrite_o <= 1'b0;
				MemtoReg_o <= 1'b0;
			end
			
			//OP_ADDI
			6'b010011:
			begin
				RegWrite_o <= 1'b1;
				ALUOp_o <= 3'b000;
				ALUSrc_o <= 1'b1;
				RegDst_o <= 1'b0;
				Jump_o <= 1'b0;
				Branch_o <= 1'b0;
				BranchType_o <= 2'b00;
				MemRead_o <= 1'b0;
				MemWrite_o <= 1'b0;
				MemtoReg_o <= 1'b0;
			end
			
			//OP_LW
			6'b011000:
			begin
				RegWrite_o <= 1'b1;
				ALUOp_o <= 3'b000;
				ALUSrc_o <= 1'b1;
				RegDst_o <= 1'b0;
				Jump_o <= 1'b0;
				Branch_o <= 1'b0;
				BranchType_o <= 2'b00;
				MemRead_o <= 1'b1;
				MemWrite_o <= 1'b0;
				MemtoReg_o <= 1'b1;
			end
			
			//OP_SW
			6'b101000:
			begin
				RegWrite_o <= 1'b0;
				ALUOp_o <= 3'b000;
				ALUSrc_o <= 1'b1;
				RegDst_o <= 1'b0;
				Jump_o <= 1'b0;
				Branch_o <= 1'b0;
				BranchType_o <= 2'b00;
				MemRead_o <= 1'b0;
				MemWrite_o <= 1'b1;
				MemtoReg_o <= 1'b0;
			end
			
			//OP_BEQ
			6'b011001:
			begin
				RegWrite_o <= 1'b0;
				ALUOp_o <= 3'b001;
				ALUSrc_o <= 1'b0;
				RegDst_o <= 1'b0;
				Jump_o <= 1'b0;
				Branch_o <= 1'b1;
				BranchType_o <= 2'b00;
				MemRead_o <= 1'b0;
				MemWrite_o <= 1'b0;
				MemtoReg_o <= 1'b0;
			end
			
			//OP_BNE
			6'b011010:
			begin
				RegWrite_o <= 1'b0;
				ALUOp_o <= 3'b001;
				ALUSrc_o <= 1'b0;
				RegDst_o <= 1'b0;
				Jump_o <= 1'b0;
				Branch_o <= 1'b1;
				BranchType_o <= 2'b01;
				MemRead_o <= 1'b0;
				MemWrite_o <= 1'b0;
				MemtoReg_o <= 1'b0;
			end
			
			//OP_JUMP
			6'b001100:
			begin
				RegWrite_o <= 1'b0;
				ALUOp_o <= 3'b000;
				ALUSrc_o <= 1'b0;
				RegDst_o <= 1'b0;
				Jump_o <= 1'b1;
				Branch_o <= 1'b0;
				BranchType_o <= 2'b00;
				MemRead_o <= 1'b0;
				MemWrite_o <= 1'b0;
				MemtoReg_o <= 1'b0;
			end
			
			//OP_JAL
			6'b001111:
			begin
				RegWrite_o <= 1'b0;
				ALUOp_o <= 3'b000;
				ALUSrc_o <= 1'b0;
				RegDst_o <= 1'b0;
				Jump_o <= 1'b1;
				Branch_o <= 1'b0;
				BranchType_o <= 2'b00;
				MemRead_o <= 1'b0;
				MemWrite_o <= 1'b0;
				MemtoReg_o <= 1'b0;
				//Reg_File[31] <= pc_out_o + 32'd4;
			end
			
			//OP_BLT
			6'b011100:
			begin
				RegWrite_o <= 1'b0;
				ALUOp_o <= 3'b011;
				ALUSrc_o <= 1'b0;
				RegDst_o <= 1'b0;
				Jump_o <= 1'b0;
				Branch_o <= 1'b1;
				BranchType_o <= 2'b10;
				MemRead_o <= 1'b0;
				MemWrite_o <= 1'b0;
				MemtoReg_o <= 1'b0;
			end
			
			//OP_BNEZ
			6'b011101:
			begin
				RegWrite_o <= 1'b0;
				ALUOp_o <= 3'b100;
				ALUSrc_o <= 1'b0;
				RegDst_o <= 1'b0;
				Jump_o <= 1'b0;
				Branch_o <= 1'b1;
				BranchType_o <= 2'b10;
				MemRead_o <= 1'b0;
				MemWrite_o <= 1'b0;
				MemtoReg_o <= 1'b0;
			end
			
			//OP_BGEZ
			6'b011110:
			begin
				RegWrite_o <= 1'b0;
				ALUOp_o <= 3'b101;
				ALUSrc_o <= 1'b0;
				RegDst_o <= 1'b0;
				Jump_o <= 1'b0;
				Branch_o <= 1'b1;
				BranchType_o <= 2'b10;
				MemRead_o <= 1'b0;
				MemWrite_o <= 1'b0;
				MemtoReg_o <= 1'b0;
			end
			
			default: 
			begin
				RegWrite_o <= 1'b0;
				ALUOp_o <= 3'b000;
				ALUSrc_o <= 1'b0;
				RegDst_o <= 1'b0;
				Jump_o <= 1'b0;
				Branch_o <= 1'b0;
				BranchType_o <= 2'b00;
				MemRead_o <= 1'b0;
				MemWrite_o <= 1'b0;
				MemtoReg_o <= 1'b0;
			end
		endcase
	end
	
	
	
endmodule
