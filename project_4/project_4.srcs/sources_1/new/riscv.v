`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/30 19:16:13
// Design Name: 
// Module Name: riscv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"
module riscv(
    input                   clk,
    input                   rst,
    
    //rom
    //取得的指令
    input   [`RegBus]       rom_data_i,
    //储存器的使能信号
    output                  rom_ce_o,
    //输出到指令储存器的地址
    output  [`RegBus]       rom_addr_o,

    //ram
    input  wire [`RegBus]   ram_data_i,
	output wire [`RegBus]   ram_addr_o,
	output wire [`RegBus]   ram_data_o,
    output wire [3:0] 		ram_sel_o,
	output wire 			ram_we_o,	
	output wire 			ram_ce_o,
    output wire[`InstAddrBus]      pc1
	//output      [`RegBus]   data_o
    );

    //指令地址
    wire[`InstAddrBus]      pc;
    //当前指令的地址
    wire[`InstAddrBus]      id_pc_i;
    //当前指令
    wire[`InstBus]          id_inst_i;
    //跳转指令  
    wire                    jump_flag;
    wire[`InstAddrBus]      jump_addr;
    //译码声明
    //连接码阶段ID模块的输出与ID/EX的输入
    //为什么每个功能模块都有连个模块进行控制呢
    //第一个模块一般都是执行功能的模块，
    //第二个模块一般都是进行时序控制的模块，有利于时钟上升沿是进行控制
    wire[`AluOpBus]         id_aluop_o;
    wire[`AluSelBus]        id_alusel_o;
    wire[`RegBus]           id_reg1_o;
    wire[`RegBus]           id_reg2_o;
    //是否写入目的寄存器
    wire                    id_wreg_o;
    wire[`RegAddrBus]       id_wd_o;
    wire[`RegBus]           id_imm_o;

    //连接ID/EX模块到执行模块EX
    wire[`AluOpBus]         ex_aluop_i;
    wire[`AluSelBus]        ex_alusel_i;
    wire[`RegBus]           ex_reg1_i;
    wire[`RegBus]           ex_reg2_i;
    //是否写入目的寄存器
    wire                    ex_wreg_i;
    wire[`RegAddrBus]       ex_wd_i;
    wire[`RegBus]           ex_imm_i;

    //连接到执行模块EX到EX/MEM模块
    //使能端，是否写入目的寄存器
    wire                    ex_wreg_o;
    //目的寄存器的地址
    wire[`RegAddrBus]       ex_wd_o;
    //要进行写入的值，运算结果
    wire[`RegBus]           ex_wdata_o;
    //访存
    wire[`AluOpBus]         ex_aluop_o;
    wire[`RegBus]           ex_mem_addr_o;


    //连接EX/MEM模块到访存MEM模块
    wire                    mem_wreg_i;
    wire[`RegAddrBus]       mem_wd_i;
    wire[`RegBus]           mem_wdata_i;
    //访存
    wire[`AluOpBus]         mem_aluop_i;
    wire[`RegBus]           mem_mem_addr_i;

    //连接访存MEM模块到MEM/WB模块
    wire                    mem_wreg_o;
    wire[`RegAddrBus]       mem_wd_o;
    wire[`RegBus]           mem_wdata_o;              

    //连接MEM/WB模块到写回模块，即Regfile
    wire                    wb_wreg_i;
    wire[`RegAddrBus]       wb_wd_i;
    wire[`RegBus]           wb_wdata_i;

    //连接译码阶段ID与通用寄存器ID
    wire                    reg1_read;
    wire                    reg2_read;
    wire[`RegBus]           reg1_data;
    wire[`RegBus]           reg2_data;
    wire[`RegAddrBus]       reg1_addr;
    wire[`RegAddrBus]       reg2_addr;


    //传值，实例化模块
    //pc模块
    pc_reg pc_reg0(
        //input
        .clk        (clk),
        .rst        (rst),
        .jump_flag_ex_i(jump_flag),
        .jump_addr_ex_i(jump_addr),
        //output
        .pc         (pc),
        .ce         (rom_ce_o)
    );
    
    //记住当前取地址的pc指令
    assign  rom_addr_o = pc;
    assign  pc1 = pc;

    //取指令模块IF/ID实例化，直到这儿将pc的指令取出，pc仍然在自增，为了得到其他的指令，总线这个概念很重要
    if_id if_id0(
        //input
        .clk        (clk),
        .rst        (rst),

        //output
        .if_pc      (pc),
        .if_inst    (rom_data_i),
        .id_pc      (id_pc_i),
        .id_inst    (id_inst_i)
    );

    //译码模块ID实例化，直到这儿，将取到的指令，进行分解，得到相应的地址
    id id0(
        .rst        (rst),
        .pc_i       (id_pc_i),
        .inst_i     (id_inst_i),

        .reg1_data_i(reg1_data),
        .reg2_data_i(reg2_data),

        //送入regfile的信息
        .reg1_read_o(reg1_read),
        .reg2_read_o(reg2_read),
        .reg1_addr_o(reg1_addr),
        .reg2_addr_o(reg2_addr),

        //送到ID/EX模块的信息
        .aluop_o        (id_aluop_o),
        .alusel_o       (id_alusel_o),
        .reg1_o         (id_reg1_o),
        .reg2_o         (id_reg2_o),
        .wd_o           (id_wd_o),
        .wreg_o         (id_wreg_o),
        .imm            (id_imm_o)
    );

    //ID/EX模块实例化
    regfile regfile0(
        .clk            (clk),
        .rst            (rst),
        //写端口
        
        .we             (wb_wreg_i),
        .waddr          (wb_wd_i),
        .wdata          (wb_wdata_i),
        //读端口,reg1_data是输出
        .re1            (reg1_read),
        .raddr1         (reg1_addr),
        .rdata1         (reg1_data),
        .re2            (reg2_read),
        .raddr2         (reg2_addr),
        .rdata2         (reg2_data)
    );

    //id
    id_ex id_ex0(
        .clk(clk),
        .rst(rst),

        //从译码阶段得到的信息
        //输入
        .id_aluop(id_aluop_o),
        .id_alusel(id_alusel_o),
        .id_reg1(id_reg1_o),
        .id_reg2(id_reg2_o),
        .id_wd(id_wd_o),
        .id_wreg(id_wreg_o),
        .id_imm(id_imm_o),

        //传递到EX模块
        //输出
        .ex_aluop(ex_aluop_i),
        .ex_alusel(ex_alusel_i),
        .ex_reg1(ex_reg1_i),
        .ex_reg2(ex_reg2_i),
        .ex_wd(ex_wd_i),
        .ex_wreg(ex_wreg_i),
        .ex_imm(ex_imm_i)
    );

    //执行模块EX
    ex ex0(
        .rst(rst),
        .clk(clk),

        //送到执行模块EX的信息
        .aluop_i(ex_aluop_i),
        .alusel_i(ex_alusel_i),
        .reg1_i(ex_reg1_i),
        .reg2_i(ex_reg2_i),
        .wd_i(ex_wd_i),
        .wreg_i(ex_wreg_i),
        .imm_i(ex_imm_i),
        .inst_addr_i(pc),

        //从EX模块送到EX/MEM模块的信息
        .wd_o(ex_wd_o),
        .wreg_o(ex_wreg_o),
        .wdata_o(ex_wdata_o),
        .aluop_o(ex_aluop_o),
        .mem_addr_o(ex_mem_addr_o),
        .jump_flag_o(jump_flag),
        .jump_addr_o(jump_addr)
    );

    //EXE/MEM
    ex_mem ex_mem0(
        .clk(clk),
        .rst(rst),

        .ex_wd(ex_wd_o),
        .ex_wreg(ex_wreg_o),
        .ex_wdata(ex_wdata_o),
        .aluop_i(ex_aluop_o),
        .mem_addr_i(ex_mem_addr_o),

        .mem_wd(mem_wd_i),
        .mem_wreg(mem_wreg_i),
        .mem_wdata(mem_wdata_i),
        .aluop_o(mem_aluop_i),
        .mem_addr_o(mem_mem_addr_i)
    );

    //MEM
    mem mem0(
        .clk(clk),
        .rst(rst),

        .wd_i(mem_wd_i),
        .wreg_i(mem_wreg_i),
        .wdata_i(mem_wdata_i),
        //ram的输入数据，最终要写入reg中
        .mem_data_i(ram_data_i),

        .aluop_i(mem_aluop_i),
        .mem_addr_i(mem_mem_addr_i),
        //输出
        .wd_o(mem_wd_o),
        .wreg_o(mem_wreg_o),
        .wdata_o(mem_wdata_o),

        .mem_addr_o(ram_addr_o),
        .mem_data_o(ram_data_o),
        .mem_we(ram_we_o),
        .mem_sel_o(ram_sel_o),
        .mem_ce_o(ram_ce_o)
    );


    //MEM/WB
    mem_wb mem_wb0(
        .clk(clk),
        .rst(rst),

        .mem_wd(mem_wd_o),
        .mem_wreg(mem_wreg_o),
        .mem_wdata(mem_wdata_o),

        .wb_wd(wb_wd_i),
        .wb_wreg(wb_wreg_i),
        .wb_wdata(wb_wdata_i)
    );
endmodule