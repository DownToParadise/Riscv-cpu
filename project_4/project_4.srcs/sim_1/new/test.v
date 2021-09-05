`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 19:15:20
// Design Name: 
// Module Name: test
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


module test();
    reg   D0, D1,SEL;
    wire LED;
mux testa(
    .D0(D0),
    .D1(D1),
    .SEL(SEL),
    .LED(LED)
    );
    
initial begin
        #0  SEL = 0;
            D1 = 0;
            D0 = 0;
        #100  SEL = 0;
            D1 = 0;
            D0 = 1;
        #100  SEL = 0;
            D1 = 1;
            D0 = 0;
        #100  SEL = 0;
            D1 = 1;
            D0 = 1;
        #100  SEL = 1;
            D1 = 0;
            D0 = 0;
        #100  SEL = 1;
            D1 = 0;
            D0 = 1;       
        #100  SEL = 1;
            D1 = 1;
            D0 = 0;
        #100  SEL = 1;
            D1 = 1;
            D0 = 1;               
            
         #100 $finish;
end

        
endmodule
