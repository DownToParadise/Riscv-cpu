`timescale 1ns / 1ps
//inst分为instruction的缩写，表示指令的意思
/************************define for all*****************/
`define RstEnable       1'b1
`define RstDisable      1'b0
`define ZeroWord        32'h0000_0000
`define WriteEnable     1'b1
`define WriteDisable    1'b0
`define ReadEnable      1'b1
`define ReadDisable     1'b0
`define AluOpBus        7:0
`define AluSelBus       2:0
`define InstValid       1'b1
`define InstInvalid     1'b0
`define True_v          1'b1
`define False_v         1'b0
`define JumpDisable     1'b0
`define JumpEnable      1'b1
//ChipEnable表示指令存储器启用
//ChipDisable表示指令存储器禁用，及无法取指令
`define ChipEnable      1'b1
`define ChipDisable     1'b0
//*****************Define for instruction  I-Type***********//
`define EXE_ORI 			3'b110			//funct3 ori
`define EXE_LW				3'b010			//funct3 lw
`define EXE_SW				3'b010
`define EXE_ADD				3'b000			//funct3 add
`define EXE_AND             3'B111          //funct3 and
`define EXE_SLT				3'b010			//funct3 slt
`define EXE_SLTU			3'b011			//funct3 sltu
`define EXE_BEQ             3'b000
`define EXE_NOP				6'b000000

`define EXE_OR_OP 			7'b0010011		//Opcode ori
`define EXE_LW_OP 			7'b0000011		//Opcode lw
`define EXE_SW_OP			7'b0100011
`define EXE_U_LUI_OP		7'b0110111		//Opcode lui
`define EXE_R_OP			7'b0110011		//Opcode R type  add slt sltu
`define EXE_JAL_OP          7'b1101111 		//Opcode jal
`define EXE_BEQ_OP			7'b1100011		//Opcode beq 
//**************************AluCase********************************//
`define ALU_ORI_OP		    8'b00000001
`define ALU_LW_OP			8'b00000010
`define ALU_LUI_OP		    8'b00000100
`define ALU_ADD_OP		    8'b00001000
`define ALU_SLT_OP	    	8'b00010000
`define ALU_SLTU_OP	    	8'b00100000
`define ALU_JAL_OP          8'b01000000
`define ALU_BEQ_OP		    8'b10000000
`define ALU_SW_OP			8'b00000011
`define ALU_NOP_OP			8'b00000000
//Alusel
`define EXE_RES_LOGIC		3'b001          //逻辑运算
`define EXE_RES_LOAD		3'b010          //装载，写入
`define EXE_RES_ARITH		3'b011          //算数运算
`define EXE_RES_JUMP        3'b100          //跳转
`define EXE_RES_NOP			3'b000
/************************define for inst_rom*****************/
`define InstAddrBus         31:0
`define InstBus             31:0
`define InstMemNum          131071
`define InstMemNumLog2      17
/************************define for data_ram*****************/
`define DataAddrBus			31:0
`define DataBus				31:0
`define DataMemNum			131071
`define DataMemNumLog2 		17
`define ByteWidth			7:0
/************************define for regfile*****************/
`define RegAddrBus      4:0
`define RegBus          31:0
`define RegWidth        32
`define DoubleRegWidth  64
`define DoubleRegbus    63:0
`define RegNum          32
`define RegNumlog2      5
`define NOPRegAddr      5'b00000