`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2023 08:36:03 AM
// Design Name: 
// Module Name: interrupt_controller
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


module interrupt_controller(
    input clock,
    input reset,            
    input stack_push_pc,        //Control signal that indicates that the interrupt has been attended
    input [7:0] IE_i,           //IE register
    input [7:0] TCON_i,         //TCON register
    input EI0_i,                //Button input for external interrupt
    output TF0_clr,             //Control signal to clear Timer 0 overflow flag
    output reg [7:0] ISR_v,     //ISR vector
    output reg ISR_req          //Signal to indicate that there is an interrupt to be serviced
    );
    
    assign TF0_clr = (ISR_req == 1'b1) ? 1'b1 : 1'b0; //If the interrupt has been requested the timer overflow flag is automatically cleared
    
    always @(posedge clock)
    begin
        if(reset)
        begin
            ISR_v = 0;
            ISR_req = 0;
        end
        if(stack_push_pc) begin  //If stack_push_pc is high it means that the interrupt request has been attended
            ISR_req = 1'b0;
        end
        else if(EI0_i && IE_i[7] && IE_i[0] && !ISR_req) //External interrupt 0
        begin
            ISR_req = 1'b1;
            ISR_v = 16'h0004;
        end 
        
        else if(TCON_i[5] && IE_i[7] && IE_i[1] && !ISR_req) //Timer 0 interrupt
        begin
            ISR_req = 1'b1;
            ISR_v = 16'h000C;
        end 
      
    end
endmodule
