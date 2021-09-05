`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 09:32:10
// Design Name: 
// Module Name: tb_PC
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


module tb_PC();
    reg clk = 1'b1;
    reg rst;
    wire [31:0] inst;
    always #10 clk = ~clk;
    initial begin
        rst = 1'b1;
        #195 rst = 1'b0;
        #1000 $stop;
    end
    inst_fetch inst_fetch0
    (
        .clk(clk),
        .rst(rst),
        .inst(inst)
    );
endmodule
