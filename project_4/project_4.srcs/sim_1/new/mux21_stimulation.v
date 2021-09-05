`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 19:33:49
// Design Name: 
// Module Name: mux21_stimulation
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


module mux21_stimulation(

    );
        reg   D0, D1,SEL;
        wire LED;
mux test(
    .D0(D0),
    .D1(D1),
    .SEL(SEL),
    .LED(LED)
    );
        
initial begin
        #0      SEL = 0;
                D1 = 0;
                D0 = 0;
        #100    SEL = 0;
                D1 = 0;
                D0 = 1;
        #100    SEL = 0;
                D1 = 1;
                D0 = 0;
        #100    SEL = 0;
                D1 = 1;
                D0 = 1;
        #100    SEL = 1;
                D1 = 0;
                D0 = 0;
        #100    SEL = 1;
                D1 = 0;
                D0 = 1;       
        #100    SEL = 1;
                D1 = 1;
                D0 = 0;
        #100    SEL = 1;
                D1 = 1;
                D0 = 1;               
                    
        #100    $finish;
end

endmodule
