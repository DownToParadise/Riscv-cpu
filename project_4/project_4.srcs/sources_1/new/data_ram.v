`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/09 13:46:53
// Design Name: 
// Module Name: data_ram
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
module data_ram(

	input   wire									clk,
	input   wire									ce,//使能端
	input   wire									we,//写入标记
	input   wire[`DataAddrBus]			            addr,
	input   wire[3:0]								sel,//4*8, 4位，写入不同的芯片中
	input   wire[`DataBus]						    data_i,
	output  reg[`DataBus]					        data_o
	
);
    //该数据存储器是由四个128K*8的ram芯片组成
	reg[`ByteWidth]  data_mem0[0:`DataMemNum-1];
	reg[`ByteWidth]  data_mem1[0:`DataMemNum-1];
	reg[`ByteWidth]  data_mem2[0:`DataMemNum-1];
	reg[`ByteWidth]  data_mem3[0:`DataMemNum-1];
    //reg[`DataAddrBus] ad = `ZeroWord;
    
    //写入
	always @ (posedge clk) begin
		if (ce == `ChipDisable) begin
			data_o <= `ZeroWord;
		end else if(we == `WriteEnable) begin
			if (sel[3] == 1'b1) begin
		      data_mem3[addr[`DataMemNumLog2+1:2]] <= data_i[31:24];
		    end
			if (sel[2] == 1'b1) begin
		      data_mem2[addr[`DataMemNumLog2+1:2]] <= data_i[23:16];
		    end
		    if (sel[1] == 1'b1) begin
		      data_mem1[addr[`DataMemNumLog2+1:2]] <= data_i[15:8];
		    end
		    if (sel[0] == 1'b1) begin
		      data_mem0[addr[`DataMemNumLog2+1:2]] <= data_i[7:0];
		    end			   	    
		end
	end
	
	
    //读取
	always @ (*) begin
		if (ce == `ChipDisable) begin
			data_o <= `ZeroWord;
	  end else if(we == `WriteDisable) begin
		  if(addr == `ZeroWord)begin
			  data_o <= 32'h0000_00ff;
		  end else begin
				data_o <= {data_mem3[addr[`DataMemNumLog2+1:2]],
						data_mem2[addr[`DataMemNumLog2+1:2]],
						data_mem1[addr[`DataMemNumLog2+1:2]],
						data_mem0[addr[`DataMemNumLog2+1:2]]};
		  end
		end else begin
				//不知道咋回事，一般情况会掉到这里
				data_o <= `ZeroWord;
				//data_o <= 32'h0000_00ff;
		end
	end		

endmodule