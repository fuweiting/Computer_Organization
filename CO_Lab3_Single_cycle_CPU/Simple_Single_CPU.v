`include "Program_Counter.v"
`include "Adder.v"
`include "Instr_Memory.v"
`include "Mux2to1.v"
`include "Mux3to1.v"
`include "Reg_File.v"
`include "Decoder.v"
`include "ALU_Ctrl.v"
`include "Sign_Extend.v"
`include "Zero_Filled.v"
`include "ALU.v"
`include "Shifter.v"
`include "Data_Memory.v"

module Simple_Single_CPU (
    clk_i,
    rst_n
);

  //I/O port
  input clk_i;
  input rst_n;

  //Internal Signles
	wire [32-1:0] ALU_result, Shifter_result, instr_o, writeData, ReadData1, ReadData2, pc_in_i, pc_out_o, SE_out, ZF_out, mux_ALUsrc_out,
	    adder_out1, adder_out2, mux_branch_out, mux_jump_out, mux_RDdata_out, MemRead_data;
	
	wire [5-1:0] write_Reg_address;
	
	wire [4-1:0] ALU_operation;
	
	wire [3-1:0] ALUOp;
	
	wire [2-1:0] FURslt, BranchType;
	
	wire leftRight, ALU_zero, ALU_overflow, Mux_BranchType_out;
	
	wire RegWrite, ALUSrc, RegDst, Jump, Branch, MemRead, MemWrite, MemtoReg, JumpRegister;
	
	assign JumpRegister = ((instr_o[5:0] == 6'b000001) && (instr_o[31:26] == 6'b000000)) ? 1 : 0;
	
  //modules
  Program_Counter PC (
      .clk_i(clk_i),
      .rst_n(rst_n),
      .pc_in_i(pc_in_i),
      .pc_out_o(pc_out_o)
  );

  Adder Adder1 (
      .src1_i(pc_out_o),
      .src2_i(32'd4),
      .sum_o (adder_out1)
  );

  Adder Adder2 (
      .src1_i(adder_out1),
      .src2_i({SE_out[29:0], 2'b00}),
      .sum_o (adder_out2)
  );
  
  Mux3to1 #(
      .size(1)
  ) Mux_BranchType (
      .data0_i (ALU_zero),
      .data1_i (~ALU_zero),
      .data2_i (ALU_result[0]),
      .select_i(BranchType),
      .data_o  (Mux_BranchType_out)
  );

  Mux2to1 #(
      .size(32)
  ) Mux_branch (
      .data0_i (adder_out1),
      .data1_i (adder_out2),
      .select_i(Branch & Mux_BranchType_out),
      .data_o  (mux_branch_out)
  );

  Mux2to1 #(
      .size(32)
  ) Mux_jump (
      .data0_i (mux_branch_out),
      .data1_i ({adder_out1[31:28], instr_o[25:0], 2'b00}),
      .select_i(Jump),
      .data_o  (mux_jump_out)
  );
  
  Mux2to1 #(
      .size(32)
  ) Mux_jumpReg (
      .data0_i (mux_jump_out),
      .data1_i (ReadData1),
      .select_i(JumpRegister),
      .data_o  (pc_in_i)
  );

  Instr_Memory IM (
      .pc_addr_i(pc_out_o),
      .instr_o  (instr_o)
  );

  Mux2to1 #(
      .size(5)
  ) Mux_Write_Reg (
      .data0_i (instr_o[20:16]),
      .data1_i (instr_o[15:11]),
      .select_i(RegDst),
      .data_o  (write_Reg_address)
  );

  Reg_File RF (
      .clk_i(clk_i),
      .rst_n(rst_n),
      .RSaddr_i(instr_o[25:21]),
      .RTaddr_i(instr_o[20:16]),
      .RDaddr_i(write_Reg_address),
      .RDdata_i(writeData),
      .RegWrite_i(RegWrite),
      .RSdata_o(ReadData1),
      .RTdata_o(ReadData2)
  );

  Decoder Decoder (
      .instr_op_i(instr_o[31:26]),
      .RegWrite_o(RegWrite),
      .ALUOp_o(ALUOp),
      .ALUSrc_o(ALUSrc),
      .RegDst_o(RegDst),
      .Jump_o(Jump),
      .Branch_o(Branch),
      .BranchType_o(BranchType),
      .MemRead_o(MemRead),
      .MemWrite_o(MemWrite),
      .MemtoReg_o(MemtoReg)
  );

  ALU_Ctrl AC (
      .funct_i(instr_o[5:0]),
      .ALUOp_i(ALUOp),
      .ALU_operation_o(ALU_operation),
      .FURslt_o(FURslt),
      .leftRight_o(leftRight)
  );

  Sign_Extend SE (
      .data_i(instr_o[15:0]),
      .data_o(SE_out)
  );

  Zero_Filled ZF (
      .data_i(instr_o[15:0]),
      .data_o(ZF_out)
  );

  Mux2to1 #(
      .size(32)
  ) ALU_src2Src (
      .data0_i (ReadData2),
      .data1_i (SE_out),
      .select_i(ALUSrc),
      .data_o  (mux_ALUsrc_out)
  );

  ALU ALU (
      .aluSrc1(ReadData1),
      .aluSrc2(mux_ALUsrc_out),
      .ALU_operation_i(ALU_operation),
      .result(ALU_result),
      .zero(ALU_zero),
      .overflow(ALU_overflow)
  );

  Shifter shifter (
      .result(Shifter_result),
      .leftRight(leftRight),
      .shamt(instr_o[10:6]),
      .sftSrc(mux_ALUsrc_out)
  );

  Mux3to1 #(
      .size(32)
  ) RDdata_Source (
      .data0_i (ALU_result),
      .data1_i (Shifter_result),
      .data2_i (ZF_out),
      .select_i(FURslt),
      .data_o  (mux_RDdata_out)
  );

  Data_Memory DM (
      .clk_i(clk_i),
      .addr_i(mux_RDdata_out),
      .data_i(ReadData2),
      .MemRead_i(MemRead),
      .MemWrite_i(MemWrite),
      .data_o(MemRead_data)
  );

  Mux2to1 #(
      .size(32)
  ) Mux_Write (
      .data0_i(mux_RDdata_out),
      .data1_i(MemRead_data),
      .select_i(MemtoReg),
      .data_o(writeData)
  );

endmodule



