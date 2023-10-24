`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2022 10:04:55 AM
// Design Name: 
// Module Name: instruction_register
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


module instruction_register(
    input clock,
    input reset,
    input ir_load_high,     //When this signal is high the most significant byte of the IR is loaded with the byte fetched from ROM
    input ir_load_low,      //When this signal is high the least significant byte of the IR is loaded with the byte fetched from ROM
    input [7:0] rom_byte,   //Byte fetched from ROM
    output reg [15:0] IR    //Stores the instruction to be executed
    );
    
    initial begin
        IR = 0;
    end
    
    always @(posedge clock)
    begin
        if(reset)           //When reset is high the IR is set to 0
        begin
            IR <= 0;
        end
        else if(ir_load_high)  //The most significant byte of IR is loaded with the rom byte
        begin
            IR[15:8] <= rom_byte;
        end
        else if (ir_load_low)  //The least significant byte of IR is loaded with the rom byte
        begin
            IR[7:0] <= rom_byte;
        end
     end
  
  
    
endmodule
