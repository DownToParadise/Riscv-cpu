`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 08:53:16
// Design Name: 
// Module Name: PC_module
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


module PC_reg(
    input   clk,
    input   rst,
    output  reg [5:0] pc,
    output  reg ce
);
always @(posedge clk) 
begin
    if(ce == 1'b0)
    begin
        pc <= 6'h00;
    end
    else
    begin
        pc <= pc+1;
    end
end
//rst使能，则使能信号ce为0，rst不使能则使能信号ce为1，pc计数器正常计数
always @(posedge clk) 
begin
    if (rst == 1'b1) begin
        ce <= 1'b0;
    end
    else
    begin
        ce <= 1'b1;
    end
end
endmodule


module rom(
    input ce,
    input [5:0] addr,
    output  reg[31:0] inst
);
    reg[31:0]   rom[63:0];
    initial $readmemh ("rom.data", rom);
    always @(*) begin
        if (ce==1'b0)
        begin
            inst <= 32'h0;
        end
        else
        begin
            inst <= rom[addr];
        end
    end
endmodule


module inst_fetch(
    input clk,
    input rst,
    output [31:0]   inst
);
    wire [5:0] pc;
    wire rom_ce;
    PC_reg pc_reg0(
        .clk(clk),
        .ce(rom_ce),
        .pc(pc),
        .rst(rst)
    );
    rom rom0(
        .inst(inst),
        .addr(pc),
        .ce(rom_ce)
    );
    
endmodule


