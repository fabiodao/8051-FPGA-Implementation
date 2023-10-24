`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2022 05:47:19 AM
// Design Name: 
// Module Name: ram
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


module ram(
    input clock,
    input reset,
    input ram_rd_en_reg,          
    input ram_wr_en_reg,
    input [2:0] ram_reg_in_sel,
    input [2:0] ram_reg_out_sel,
    input ram_rd_en_data,
    input ram_wr_en_data,
    input [7:0]ram_rd_addr,
    input [7:0]ram_wr_addr,
    input [7:0]ram_wr_byte,
    input stack_push_pc,
    input stack_pop_pc,
    input TF0_i,                   //Overflow flag from timer0
    input [15:0] pc_reti_in,       
    output [7:0]ram_rd_byte,
    output [7:0]tcon,              //Output the TCON register
    output [7:0]tmod,              //Output the TMOD register
    output [7:0] TL0,              //Output the Tl0 register
    output [7:0] TH0,              //Output the TH0 register
    output [15:0] jmp_addr_o,      //Output for the return address for the ISR
    output [7:0] PORT1_o,          //Output for the I/O port P1
    output [7:0] IE_o              //Output the IE register
    );
    
    
    reg [7:0] mem [0:255];
    integer i;
    reg [7:0] SP;
    
    //Instanciate the register bank
    register_bank REG(clock,reset,ram_wr_en_reg,ram_rd_en_reg,ram_reg_in_sel,ram_reg_out_sel,ram_wr_byte,ram_rd_byte);
    
    assign tcon = mem[8'h88];   //TCON address: 0x88h 
    assign tmod = mem[8'h89];   //TMOD address: 0x89h
    assign TL0  = mem[8'h8A];   //TL0  address: 0x8Ah
    assign TH0  = mem[8'h8C];   //TH0  address: 0x8Ch
    assign IE_o = mem[8'hA8];   //IE   address: 0xA8h
    assign PORT1_o = mem[8'h90]; //P1  address: 0x90h
    
    always @(posedge clock)
    begin
        if(reset)    //If reset is high clear RAM and set stack pointer to address 0x07h
        begin
            for(i=0; i < 256 ; i = i + 1)
            begin
                mem[i]=8'b00000000;
            end
            SP = 8'h07; 
        end
        
        mem[8'h88][5] = TF0_i;  //Update TCON with the Timer 0 overflow flag
        
        if(ram_wr_en_data == 1'b1 && ram_rd_en_reg == 1'b0)  //Write to RAM data section
        begin
            mem[ram_wr_addr] = ram_wr_byte;        
        end
        if(ram_wr_en_data == 1'b1 && ram_rd_en_reg == 1'b1)  //Write value read from register to address on RAM
        begin
            mem[ram_wr_addr] = ram_rd_byte;
        end
        if(stack_push_pc == 1'b1)  //Push the program counter to the stack when isr is going to be executed
        begin
            mem[SP] = pc_reti_in[7:0];
            mem[SP+1] = pc_reti_in[15:8];
            SP = SP+2;
        end
        else if (stack_pop_pc == 1'b1) //Pop the program counter from the stack when returning from isr
        begin
            SP = SP - 2;
        end
     end
    
     assign ram_rd_byte = (ram_rd_en_data == 1'b1 && ram_rd_en_reg == 1'b0 ) ? mem[ram_rd_addr] : 8'hzz; //Read the value from the data section of ram
     
     assign jmp_addr_o = (stack_pop_pc == 1'b1) ? {mem[SP-1], mem[SP-2]} : 16'hzzzz;  //Read the program counter from the stack
    
endmodule
