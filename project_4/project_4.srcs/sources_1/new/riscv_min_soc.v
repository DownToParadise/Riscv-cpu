`timescale 1ns / 1ps
`include "defines.v"
module riscv_min_soc(
 
	input	wire		clk,
	input  	wire		rst
	
);
	
  	// 连接inst_rom
  	wire[`InstAddrBus] 	inst_addr;
  	wire[`InstBus]    	inst;
    wire               	rom_ce;

	// 连接data_rom
	wire [`RegBus]   	ram_data_i;
	wire [`DataAddrBus] ram_addr_i;
	wire [`RegBus]   	ram_data_o;
    wire [3:0] 			ram_sel_i;
	wire 				ram_we_i;
	wire 				ram_ce_i;
	
    // 例化处理器OpenMIPS
 	riscv riscv0(
            .clk(clk),
            .rst(rst),
            .rom_addr_o(inst_addr),
            .rom_data_i(inst),
            .rom_ce_o(rom_ce),

			.ram_data_i(ram_data_o),
			.ram_data_o(ram_data_i),
			.ram_addr_o(ram_addr_i),
			.ram_sel_o(ram_sel_i),
			.ram_we_o(ram_we_i),
			.ram_ce_o(ram_ce_i)
	);
	
    // 例化指令存储器ROM
	inst_rom inst_rom0(
		.ce(rom_ce),
		.addr(inst_addr),
        .inst(inst)
	);
	
	data_ram data_ram0(
		.clk(clk),
		.ce(ram_ce_i),
		.we(ram_ce_i),
		.addr(ram_addr_i),
		.sel(ram_sel_i),
		.data_i(ram_data_i),
		.data_o(ram_data_o)
	);
endmodule
