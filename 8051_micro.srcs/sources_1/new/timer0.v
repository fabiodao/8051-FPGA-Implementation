`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2023 10:48:42 AM
// Design Name: 
// Module Name: timer0
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


module timer0(
    input clock,
    input reset,
    input [7:0] tmod,    //TMOD register
    input [7:0] tcon,    //TCON register   
    input [7:0] TH0_i,   //TH0 register
    input [7:0] TL0_i,   //TL0 register
    input TF0_clr,       //Control signal to clear the overflow flag
    output reg TF0_o     //Overflow flag
    );
   
    reg [15:0] TIMER0;
    reg [7:0] TH0;
    reg [7:0] TL0;
     
   
    always @(posedge clock)
    begin
        if(reset == 1'b1)
        begin
            TH0 = 8'h00;
            TL0 = 8'h00;
            TIMER0 = 0; 
            TF0_o = 0; 
        end
        if(TF0_clr) begin
            TF0_o = 0;
        end
        case(tmod[1:0])
            2'b01: // Mode 1: 16 bit timer
            begin
                if(tcon[4] == 1'b0) begin // timer not running
                    TH0 = TH0_i;
                    TL0 = TL0_i;
                    TF0_o = 1'b0;
                    TIMER0 = {TH0,TL0};
                end
                else if(tcon[4] == 1'b1) begin // timer running
                    TIMER0 = TIMER0 + 1;
                end
                if(TIMER0 == 16'hFFFF) begin  //overflow
                    TF0_o = 1'b1;
                end
            end
            
            2'b10: //Mode 2: 8 bit timer with auto-reload
            begin
                if(tcon[4] == 1'b0) begin
                    TH0 = TH0_i;
                    TL0 = TL0_i;
                    TF0_o = 1'b0;
                    TIMER0 = {8'h00,TL0};
                end
                if(TIMER0[7:0] == 8'hFF)
                begin
                    TF0_o = 1'b1;
                    TIMER0 = {8'h00,TH0};
                end
                else if(tcon[4] == 1'b1) begin
                    TIMER0 = TIMER0 + 1;
                end
            end
            default:
                TIMER0 = 0;
            
        endcase
      end      
        
endmodule
