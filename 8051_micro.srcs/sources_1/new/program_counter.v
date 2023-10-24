`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2022 08:10:31 AM
// Design Name: 
// Module Name: program_counter
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


module program_counter(
    input clock,
    input reset,       
    input inc,              // When this signal is high the program counter is incremented
    input set,              // When this signal is high the value on jmp_addr is added to the program counter
    input isr,              // When this signal is high the program counter is set to the isr vector present in jmp_addr
    input [15:0] jmp_addr,  // Value for the program counter to be set
    output reg [15:0] addr  // Value of the program counter
    );
    
    
    initial begin
        addr = 0;
    end
        
    always @(posedge clock) begin
    if  (reset) begin                   //If the reset signal is high the program counter is set to 0
        addr <= 0;
    end
    else if(set==1 && isr==0) begin     //If set is high the value on jmp_addr is added to the program counter
        addr <= addr + jmp_addr;
    end
    else if(inc) begin                  //If inc is high the program counter is incremented
        addr <= addr + 1;
    end
    else if(isr==1 && set==0) begin     //If isr is high the program counter is set to the jmp_addr wich is provided by the interrupt controller as the corresponding isr vector
        addr <= jmp_addr;
    end
    else if(isr==1 && set==1) begin
        addr <= addr-2;
    end
end 

endmodule
