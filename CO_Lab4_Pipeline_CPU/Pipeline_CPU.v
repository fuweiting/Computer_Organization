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
`include "Pipe_Reg_IFID.v"
`include "Pipe_Reg_IDEX.v"
`include "Pipe_Reg_EXMEM.v"
`include "Pipe_Reg_MEMWB.v"

module Pipeline_CPU (
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
	
	wire [64-1:0] IFID_out;
	
	wire [193-1:0] IDEX_out;
	
	wire [107-1:0] EXMEM_out;
	
	wire [71-1:0] MEMWB_out;
	
  //modules

/*----------IF stage---------*/

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
  
  Instr_Memory IM (
      .pc_addr_i(pc_out_o),
      .instr_o  (instr_o)
  );
  
/*----------IF stage---------*/

  Pipe_Reg_IFID  #(
      .size(64)
  ) Reg_IFID (
	  .clk_i(clk_i),
	  .rst_n(rst_n),
      .data_i ({adder_out1,	//IFID_out[63:32]
				instr_o}),	//IFID_out[31:0]
      .data_o (IFID_out)
  );

/*----------ID stage---------*/

  Decoder Decoder (
      .instr_op_i(IFID_out[31:26]),	//instr_o[31:26]
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
  
  Reg_File RF (
      .clk_i(clk_i),
      .rst_n(rst_n),
      .RSaddr_i(IFID_out[25:21]),	//instr_o[25:21]
      .RTaddr_i(IFID_out[20:16]),	//instr_o[20:16]
      .RDaddr_i(MEMWB_out[4:0]),	//write_Reg_address
      .RDdata_i(writeData),
      .RegWrite_i(MEMWB_out[70]),	//RegWrite
      .RSdata_o(ReadData1),
      .RTdata_o(ReadData2)
  );
  
  Sign_Extend SE (
      .data_i(IFID_out[15:0]),	//instr_o[15:0]
      .data_o(SE_out)
  );

  Zero_Filled ZF (
      .data_i(IFID_out[15:0]),	//instr_o[15:0]
      .data_o(ZF_out)
  );
  
/*----------ID stage---------*/

  Pipe_Reg_IDEX  #(
      .size(193)
  ) Reg_IDEX (
	  .clk_i(clk_i),
	  .rst_n(rst_n),
      .data_i ({RegWrite,			//IDEX_out[192]
				MemtoReg,			//IDEX_out[191]
				Branch,				//IDEX_out[190]
				MemRead,			//IDEX_out[189]
				MemWrite,			//IDEX_out[188]
				RegDst,				//IDEX_out[187]
				BranchType,			//IDEX_out[186:185]
				ALUOp,				//IDEX_out[184:182]
				ALUSrc,				//IDEX_out[181]
				IFID_out[63:32],	//IDEX_out[180:149]	(adder_out1)
				ReadData1,			//IDEX_out[148:117]
				ReadData2,			//IDEX_out[116:85]
				SE_out,				//IDEX_out[84:53]
				ZF_out,				//IDEX_out[52:21]
				IFID_out[10:6],		//IDEX_out[20:16]	(instr_o[10:6])
				IFID_out[5:0],		//IDEX_out[15:10]	(instr_o[5:0])
				IFID_out[20:16],	//IDEX_out[9:5]		(instr_o[20:16])
				IFID_out[15:11]}),	//IDEX_out[4:0]		(instr_o[15:11])
      .data_o (IDEX_out)
  );

/*----------EX stage---------*/

  Adder Adder2 (
      .src1_i(IDEX_out[180:149]),			//adder_out1
      .src2_i({IDEX_out[82:53], 2'b00}),	//SE_out[29:0] << 2
      .sum_o (adder_out2)
  );
  
  Mux3to1 #(
      .size(1)
  ) Mux_BranchType (
      .data0_i (ALU_zero),
      .data1_i (~ALU_zero),
      .data2_i (ALU_result[0]),
      .select_i(IDEX_out[186:185]),		//BranchType
      .data_o  (Mux_BranchType_out)
  );

  Mux2to1 #(
      .size(32)
  ) ALU_src2Src (
      .data0_i (IDEX_out[116:85]),		//ReadData2
      .data1_i (IDEX_out[84:53]),		//SE_out
      .select_i(IDEX_out[181]),			//ALUSrc
      .data_o  (mux_ALUsrc_out)
  );

  ALU ALU (
      .aluSrc1(IDEX_out[148:117]),			//ReadData1
      .aluSrc2(mux_ALUsrc_out),
      .ALU_operation_i(ALU_operation),
      .result(ALU_result),
      .zero(ALU_zero),
      .overflow(ALU_overflow)
  );

  Shifter shifter (
      .result(Shifter_result),
      .leftRight(leftRight),
      .shamt(IDEX_out[20:16]),	//instr_o[10:6]
      .sftSrc(mux_ALUsrc_out)
  );

  Mux3to1 #(
      .size(32)
  ) RDdata_Source (
      .data0_i (ALU_result),
      .data1_i (Shifter_result),
      .data2_i (IDEX_out[52:21]),	//ZF_out
      .select_i(FURslt),
      .data_o  (mux_RDdata_out)
  );

  ALU_Ctrl AC (
      .funct_i(IDEX_out[15:10]),			//instr_o[5:0]
      .ALUOp_i(IDEX_out[184:182]),			//ALUOp
      .ALU_operation_o(ALU_operation),
      .FURslt_o(FURslt),
      .leftRight_o(leftRight)
  );

  Mux2to1 #(
      .size(5)
  ) Mux_Write_Reg (
      .data0_i (IDEX_out[9:5]),		//instr_o[20:16]
      .data1_i (IDEX_out[4:0]),		//instr_o[15:11]
      .select_i(IDEX_out[187]),		//RegDst
      .data_o  (write_Reg_address)
  );

/*----------EX stage---------*/

  Pipe_Reg_EXMEM  #(
      .size(107)
  ) Reg_EXMEM (
	  .clk_i(clk_i),
	  .rst_n(rst_n),
      .data_i ({IDEX_out[192],			//EXMEM_out[106]	(RegWrite)
				IDEX_out[191],			//EXMEM_out[105]	(MemtoReg)
				IDEX_out[190],			//EXMEM_out[104]	(Branch)
				IDEX_out[189],			//EXMEM_out[103]	(MemRead)
				IDEX_out[188],			//EXMEM_out[102]	(MemWrite)
				adder_out2,				//EXMEM_out[101:70]	(branch target address)
				Mux_BranchType_out,		//EXMEM_out[69]		(BranchType)
				mux_RDdata_out,			//EXMEM_out[68:37]	(ALU/Shifter/ZF result)
				IDEX_out[116:85],		//EXMEM_out[36:5]	(ReadData2)
				write_Reg_address}),	//EXMEM_out[4:0]	(write_Reg_address)
      .data_o (EXMEM_out)
  );

/*----------MEM stage---------*/

  Mux2to1 #(
      .size(32)
  ) Mux_branch (
      .data0_i (adder_out1),
      .data1_i (EXMEM_out[101:70]),					//adder_out2
      .select_i(EXMEM_out[104] & EXMEM_out[69]), 	//Branch & Mux_BranchType_out	(PCSrc)
      .data_o  (pc_in_i)							//mux_branch_out if implement jump and jr
  );

  Data_Memory DM (
      .clk_i(clk_i),
      .addr_i(EXMEM_out[68:37]),	//mux_RDdata_out
      .data_i(EXMEM_out[36:5]),		//ReadData2
      .MemRead_i(EXMEM_out[103]),	//MemRead
      .MemWrite_i(EXMEM_out[102]),	//MemWrite
      .data_o(MemRead_data)
  );

/*----------MEM stage---------*/

  Pipe_Reg_MEMWB  #(
      .size(71)
  ) Reg_MEMWB (
	  .clk_i(clk_i),
	  .rst_n(rst_n),
      .data_i ({EXMEM_out[106],			//MEMWB_out[70]		(RegWrite)
				EXMEM_out[105],			//MEMWB_out[69]		(MemtoReg)
				MemRead_data,			//MEMWB_out[68:37]	(MemRead_data)
				EXMEM_out[68:37],		//MEMWB_out[36:5]	(mux_RDdata_out)
				EXMEM_out[4:0]}),		//MEMWB_out[4:0]	(write_Reg_address)
      .data_o (MEMWB_out)
  );

/*----------WB stage---------*/

  Mux2to1 #(
      .size(32)
  ) Mux_Write (
      .data0_i(MEMWB_out[36:5]),		//mux_RDdata_out
      .data1_i(MEMWB_out[68:37]),		//MemRead_data
      .select_i(MEMWB_out[69]),			//MemtoReg
      .data_o(writeData)
  );
  
/*----------WB stage---------*/


// instruction jump
  /* Mux2to1 #(
      .size(32)
  ) Mux_jump (
      .data0_i (mux_branch_out),
      .data1_i ({adder_out1[31:28], instr_o[25:0], 2'b00}),
      .select_i(Jump),
      .data_o  (mux_jump_out)
  ); */
  
// instruction jr  
  /* Mux2to1 #(
      .size(32)
  ) Mux_jumpReg (
      .data0_i (mux_jump_out),
      .data1_i (ReadData1),
      .select_i(JumpRegister),
      .data_o  (pc_in_i)
  ); */
endmodule



