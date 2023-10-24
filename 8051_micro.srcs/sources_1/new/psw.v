`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2023 10:14:24 AM
// Design Name: 
// Module Name: psw
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

/*
 _______________________________________________________
|  CY  |  AC  |  F0  |  RS1  |  RS0  |  OV  |  Z  |  P  |
  psw.7  psw.6  psw.5  psw.4   psw.3  psw.2  psw.1 psw.0 */
  
  
module psw(
    input clk,
    input rst,
    input c,            //carry bit provided by the ALU
    input ac,           //auxiliary carry bit provided by the ALU
    input ov,           //overflow bit provided by the ALU
    input z,            //zero bit provided by the ALU
    input p,            //parity bit provided by the ALU (high -> odd)
    input write_en,      //When high the PSW is updated with the bits provided above
    output reg [7:0] PSW //PSW register
    );
    
    initial begin
        PSW = 8'b00000000;
    end
   
    always @(posedge clk) begin
      if(rst)                   //When reset is high the PSW is set to 0
      begin
        PSW <= 8'b00000000;
      end
      
      if (write_en)         //When write_en is high the PSW is updated with the status bits
      begin 
        PSW[7]<=c;
        PSW[6]<=ac;
        PSW[2]<=ov;
        PSW[1]<=z;
        PSW[0]<=p;
      end
    end
    

endmodule

