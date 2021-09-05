// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Mon May 31 11:10:55 2021
// Host        : DESKTOP-VQTLGRE running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               E:/Pool_Birds/Project_of_vivado/project_4/project_4.sim/sim_1/synth/func/tb_riscv_func_synth.v
// Design      : inst_fetch
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module PC_reg
   (inst_OBUF,
    clk,
    rst_IBUF);
  output [4:0]inst_OBUF;
  input clk;
  input rst_IBUF;

  wire ce;
  wire ce_i_1_n_0;
  wire clear;
  wire clk;
  wire [4:0]inst_OBUF;
  wire \inst_OBUF[24]_inst_i_2_n_0 ;
  wire \inst_OBUF[25]_inst_i_2_n_0 ;
  wire \inst_OBUF[26]_inst_i_2_n_0 ;
  wire \inst_OBUF[27]_inst_i_2_n_0 ;
  wire \inst_OBUF[28]_inst_i_2_n_0 ;
  wire [5:0]p_0_in;
  wire [5:0]pc_reg__0;
  wire rst_IBUF;

  LUT1 #(
    .INIT(2'h1)) 
    ce_i_1
       (.I0(rst_IBUF),
        .O(ce_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    ce_reg
       (.C(clk),
        .CE(1'b1),
        .D(ce_i_1_n_0),
        .Q(ce),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \inst_OBUF[24]_inst_i_1 
       (.I0(ce),
        .I1(\inst_OBUF[24]_inst_i_2_n_0 ),
        .O(inst_OBUF[0]));
  LUT6 #(
    .INIT(64'h000011EA000115EA)) 
    \inst_OBUF[24]_inst_i_2 
       (.I0(pc_reg__0[4]),
        .I1(pc_reg__0[3]),
        .I2(pc_reg__0[2]),
        .I3(pc_reg__0[0]),
        .I4(pc_reg__0[5]),
        .I5(pc_reg__0[1]),
        .O(\inst_OBUF[24]_inst_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \inst_OBUF[25]_inst_i_1 
       (.I0(ce),
        .I1(\inst_OBUF[25]_inst_i_2_n_0 ),
        .O(inst_OBUF[1]));
  LUT6 #(
    .INIT(64'h00000001FF1100EA)) 
    \inst_OBUF[25]_inst_i_2 
       (.I0(pc_reg__0[4]),
        .I1(pc_reg__0[3]),
        .I2(pc_reg__0[2]),
        .I3(pc_reg__0[0]),
        .I4(pc_reg__0[1]),
        .I5(pc_reg__0[5]),
        .O(\inst_OBUF[25]_inst_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \inst_OBUF[26]_inst_i_1 
       (.I0(ce),
        .I1(\inst_OBUF[26]_inst_i_2_n_0 ),
        .O(inst_OBUF[2]));
  LUT6 #(
    .INIT(64'h0000F0F00001F01A)) 
    \inst_OBUF[26]_inst_i_2 
       (.I0(pc_reg__0[4]),
        .I1(pc_reg__0[3]),
        .I2(pc_reg__0[2]),
        .I3(pc_reg__0[1]),
        .I4(pc_reg__0[5]),
        .I5(pc_reg__0[0]),
        .O(\inst_OBUF[26]_inst_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \inst_OBUF[27]_inst_i_1 
       (.I0(ce),
        .I1(\inst_OBUF[27]_inst_i_2_n_0 ),
        .O(inst_OBUF[3]));
  LUT6 #(
    .INIT(64'h00CC00CC00C801C6)) 
    \inst_OBUF[27]_inst_i_2 
       (.I0(pc_reg__0[4]),
        .I1(pc_reg__0[3]),
        .I2(pc_reg__0[0]),
        .I3(pc_reg__0[5]),
        .I4(pc_reg__0[1]),
        .I5(pc_reg__0[2]),
        .O(\inst_OBUF[27]_inst_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \inst_OBUF[28]_inst_i_1 
       (.I0(ce),
        .I1(\inst_OBUF[28]_inst_i_2_n_0 ),
        .O(inst_OBUF[4]));
  LUT6 #(
    .INIT(64'h00AA00AA00AE01A8)) 
    \inst_OBUF[28]_inst_i_2 
       (.I0(pc_reg__0[4]),
        .I1(pc_reg__0[3]),
        .I2(pc_reg__0[0]),
        .I3(pc_reg__0[5]),
        .I4(pc_reg__0[1]),
        .I5(pc_reg__0[2]),
        .O(\inst_OBUF[28]_inst_i_2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \pc[0]_i_1 
       (.I0(pc_reg__0[0]),
        .O(p_0_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \pc[1]_i_1 
       (.I0(pc_reg__0[0]),
        .I1(pc_reg__0[1]),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \pc[2]_i_1 
       (.I0(pc_reg__0[0]),
        .I1(pc_reg__0[1]),
        .I2(pc_reg__0[2]),
        .O(p_0_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \pc[3]_i_1 
       (.I0(pc_reg__0[1]),
        .I1(pc_reg__0[0]),
        .I2(pc_reg__0[2]),
        .I3(pc_reg__0[3]),
        .O(p_0_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \pc[4]_i_1 
       (.I0(pc_reg__0[2]),
        .I1(pc_reg__0[0]),
        .I2(pc_reg__0[1]),
        .I3(pc_reg__0[3]),
        .I4(pc_reg__0[4]),
        .O(p_0_in[4]));
  LUT1 #(
    .INIT(2'h1)) 
    \pc[5]_i_1 
       (.I0(ce),
        .O(clear));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \pc[5]_i_2 
       (.I0(pc_reg__0[3]),
        .I1(pc_reg__0[1]),
        .I2(pc_reg__0[0]),
        .I3(pc_reg__0[2]),
        .I4(pc_reg__0[4]),
        .I5(pc_reg__0[5]),
        .O(p_0_in[5]));
  FDRE #(
    .INIT(1'b0)) 
    \pc_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(p_0_in[0]),
        .Q(pc_reg__0[0]),
        .R(clear));
  FDRE #(
    .INIT(1'b0)) 
    \pc_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(p_0_in[1]),
        .Q(pc_reg__0[1]),
        .R(clear));
  FDRE #(
    .INIT(1'b0)) 
    \pc_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(p_0_in[2]),
        .Q(pc_reg__0[2]),
        .R(clear));
  FDRE #(
    .INIT(1'b0)) 
    \pc_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(p_0_in[3]),
        .Q(pc_reg__0[3]),
        .R(clear));
  FDRE #(
    .INIT(1'b0)) 
    \pc_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(p_0_in[4]),
        .Q(pc_reg__0[4]),
        .R(clear));
  FDRE #(
    .INIT(1'b0)) 
    \pc_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(p_0_in[5]),
        .Q(pc_reg__0[5]),
        .R(clear));
endmodule

(* NotValidForBitStream *)
module inst_fetch
   (clk,
    rst,
    inst);
  input clk;
  input rst;
  output [31:0]inst;

  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [31:0]inst;
  wire [4:0]inst_OBUF;
  wire rst;
  wire rst_IBUF;

  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  OBUF \inst_OBUF[0]_inst 
       (.I(inst_OBUF[0]),
        .O(inst[0]));
  OBUF \inst_OBUF[10]_inst 
       (.I(inst_OBUF[2]),
        .O(inst[10]));
  OBUF \inst_OBUF[11]_inst 
       (.I(inst_OBUF[3]),
        .O(inst[11]));
  OBUF \inst_OBUF[12]_inst 
       (.I(inst_OBUF[4]),
        .O(inst[12]));
  OBUF \inst_OBUF[13]_inst 
       (.I(1'b0),
        .O(inst[13]));
  OBUF \inst_OBUF[14]_inst 
       (.I(1'b0),
        .O(inst[14]));
  OBUF \inst_OBUF[15]_inst 
       (.I(1'b0),
        .O(inst[15]));
  OBUF \inst_OBUF[16]_inst 
       (.I(inst_OBUF[0]),
        .O(inst[16]));
  OBUF \inst_OBUF[17]_inst 
       (.I(inst_OBUF[1]),
        .O(inst[17]));
  OBUF \inst_OBUF[18]_inst 
       (.I(inst_OBUF[2]),
        .O(inst[18]));
  OBUF \inst_OBUF[19]_inst 
       (.I(inst_OBUF[3]),
        .O(inst[19]));
  OBUF \inst_OBUF[1]_inst 
       (.I(inst_OBUF[1]),
        .O(inst[1]));
  OBUF \inst_OBUF[20]_inst 
       (.I(inst_OBUF[4]),
        .O(inst[20]));
  OBUF \inst_OBUF[21]_inst 
       (.I(1'b0),
        .O(inst[21]));
  OBUF \inst_OBUF[22]_inst 
       (.I(1'b0),
        .O(inst[22]));
  OBUF \inst_OBUF[23]_inst 
       (.I(1'b0),
        .O(inst[23]));
  OBUF \inst_OBUF[24]_inst 
       (.I(inst_OBUF[0]),
        .O(inst[24]));
  OBUF \inst_OBUF[25]_inst 
       (.I(inst_OBUF[1]),
        .O(inst[25]));
  OBUF \inst_OBUF[26]_inst 
       (.I(inst_OBUF[2]),
        .O(inst[26]));
  OBUF \inst_OBUF[27]_inst 
       (.I(inst_OBUF[3]),
        .O(inst[27]));
  OBUF \inst_OBUF[28]_inst 
       (.I(inst_OBUF[4]),
        .O(inst[28]));
  OBUF \inst_OBUF[29]_inst 
       (.I(1'b0),
        .O(inst[29]));
  OBUF \inst_OBUF[2]_inst 
       (.I(inst_OBUF[2]),
        .O(inst[2]));
  OBUF \inst_OBUF[30]_inst 
       (.I(1'b0),
        .O(inst[30]));
  OBUF \inst_OBUF[31]_inst 
       (.I(1'b0),
        .O(inst[31]));
  OBUF \inst_OBUF[3]_inst 
       (.I(inst_OBUF[3]),
        .O(inst[3]));
  OBUF \inst_OBUF[4]_inst 
       (.I(inst_OBUF[4]),
        .O(inst[4]));
  OBUF \inst_OBUF[5]_inst 
       (.I(1'b0),
        .O(inst[5]));
  OBUF \inst_OBUF[6]_inst 
       (.I(1'b0),
        .O(inst[6]));
  OBUF \inst_OBUF[7]_inst 
       (.I(1'b0),
        .O(inst[7]));
  OBUF \inst_OBUF[8]_inst 
       (.I(inst_OBUF[0]),
        .O(inst[8]));
  OBUF \inst_OBUF[9]_inst 
       (.I(inst_OBUF[1]),
        .O(inst[9]));
  PC_reg pc_reg0
       (.clk(clk_IBUF_BUFG),
        .inst_OBUF(inst_OBUF),
        .rst_IBUF(rst_IBUF));
  IBUF rst_IBUF_inst
       (.I(rst),
        .O(rst_IBUF));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
