`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 19:13:18
// Design Name: 
// Module Name: MUX2top
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


    
module MUX2top(
    input wire[2:0] sw,
    output wire led
    );
    
    mux M1(
    .D0(sw[0]),
    .D1(sw[1]),
    .SEL(sw[2]),
    .LED(led)
    );
    
endmodule

