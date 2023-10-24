`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2022 06:52:25 AM
// Design Name: 
// Module Name: tb_top
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


module tb_top();
    
    reg clock;
    reg reset;
    reg pb_1;
  
    top c8051(
        .clock(clock),
        .reset(reset),
        .pb_1(pb_1)
    ); 
    
    initial begin
        clock = 0;
        reset = 1;
        pb_1 = 0;
        
        #30;
		reset = 0;
		
		#1350
		pb_1 = 1;
		#20
		pb_1 = 0;

		
    end
    
    always #10 clock = ~clock;
    
endmodule
