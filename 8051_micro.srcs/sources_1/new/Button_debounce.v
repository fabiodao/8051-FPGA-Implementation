`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2023 11:29:52 AM
// Design Name: 
// Module Name: Button_debounce
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


module Button_debounce(
    input clock,
    input reset,
    input button,
    output reg button_out
);

  reg button_pressed;
  reg counter;
  reg [31:0] debounce_counter;
  
  initial begin
    button_pressed = 0;
    button_out = 0;
    debounce_counter = 0;
  end
  
  always @(posedge clock) begin

   if(reset) begin
        button_pressed = 0;
        button_out = 0;
        debounce_counter = 0;
    end
    if (button && !button_pressed) begin
      
      debounce_counter <= debounce_counter + 1;
      
      if (debounce_counter == 32'h00FFFFFF) begin
        counter <= 1'b1;
        button_pressed <= 1;
        debounce_counter <= 0;
      end
    
    end 
    else if (counter != 0) begin
      counter <= counter - 1;
    end 
    else begin
      button_out <= 0;
      button_pressed <= 0;
      debounce_counter <= 0;
    end
    button_out <= counter != 0;
  end
endmodule
