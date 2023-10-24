`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2023 09:21:56 AM
// Design Name: 
// Module Name: acc
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


module acc(
      input clk,
      input rst,
      input [7:0] data_in,   //data to be stored in the accumulator 
      input write_en,        //When this signal is high data_in is stored in the ACC register
      output reg [7:0] ACC   //ACC register
    );
    
    always @(posedge clk) begin
      if(rst)                //When reset is high the accumulator is set to 0
      begin
        ACC <= 0;
      end
      
      if (write_en)         //ACC is loaded with data_in when write_en is high
      begin 
        ACC <= data_in;
      end
    end

endmodule
