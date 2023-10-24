`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2022 05:27:19 AM
// Design Name: 
// Module Name: rom
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
module rom(
    input reset,
    input rom_en,           //Control signal to fetch byte from rom
    input [15:0] rom_addr,  //Address to fetch byte
    output [7:0] rom_byte   //Output the byte fetched
    );
    
    reg [7:0] ROM[0:255];
    
    
    always @(posedge reset) begin
    
    //------interrupt vectors-------------
        
        //reset
        ROM[0]  = 8'b10000000;
        ROM[1]  = 8'b00010010;

        ROM[2]  = 8'b00100100;
        ROM[3]  = 8'b00000001;
        //External 0
        ROM[4]  = 8'b11100101;
        ROM[5]  = 8'b10101000;
        
        ROM[6]  = 8'b01100100;
        ROM[7]  = 8'b00000010;
        
        ROM[8]  = 8'b11110101;
        ROM[9]  = 8'b10101000;
        
        ROM[10] = 8'b00110010;
        ROM[11] = 8'b00000000;
        
        //Timer 0
        ROM[12] = 8'b10000000;
        ROM[13] = 8'b00100010;
        
        ROM[14] = 8'b11110101;
        ROM[15] = 8'b10010000;
        
        ROM[16] = 8'b00110010;
        ROM[17] = 8'b00000000;
        
        ROM[18] = 8'b00110010;
        ROM[19] = 8'b00000000;
  //----------------------------------------      
  //---------------code---------------------    
        /*ROM[20]  = 8'b01110100; //MOV A, #02h
        ROM[21]  = 8'b00000010;
        
        ROM[22]  = 8'b11110101; //MOV TMOD, A
        ROM[23]  = 8'b10001001;
        
        ROM[24]  = 8'b01110100 ; //MOV A, #F0h
        ROM[25]  = 8'b11110000;
        
        ROM[26]  = 8'b11110101; //MOV TL0, A
        ROM[27]  = 8'b10001010; 
        
        ROM[28]  = 8'b01110100; //MOV A, #F0h
        ROM[29]  = 8'b11110000;
        
        ROM[30] = 8'b11110101; // MOV TH0, A
        ROM[31] = 8'b10001100;
                
        ROM[32] = 8'b01110100; // MOV A, #10h
        ROM[33] = 8'b00010000;
        
        ROM[34] = 8'b11110101; //MOV TCON, A
        ROM[35] = 8'b10001000;
        
        ROM[36] = 8'b11110111;
        ROM[37] = 8'b00000000;
        
        ROM[38] = 8'b11110111;
        ROM[39] = 8'b00000000;
        
        ROM[40] = 8'b01110100; // MOV A, #10h
        ROM[41] = 8'b00010000;
        
        ROM[42] = 8'b11110101; // MOV TCON, A
        ROM[43] = 8'b10001000;*/
        
        ROM[20]  = 8'b01110100; //MOV A, #01h
        ROM[21]  = 8'b00000001;
        
        ROM[22]  = 8'b11110101; //MOV TMOD, A
        ROM[23]  = 8'b10001001;
        
        ROM[24]  = 8'b01110100 ; //MOV A, #00h
        ROM[25]  = 8'b00000000;
        
        ROM[26]  = 8'b11110101; //MOV TL0, A
        ROM[27]  = 8'b10001010; 
        
        ROM[28]  = 8'b01110100; //MOV A, #00h
        ROM[29]  = 8'b00000000;
        
        ROM[30] = 8'b11110101; // MOV TH0, A
        ROM[31] = 8'b10001100;
        
        ROM[32] = 8'b01111000; //MOV R0, #00h
        ROM[33] = 8'b00000000;
        
        ROM[34] = 8'b01111001; // MOV R1, #00h
        ROM[35] = 8'b00000000;
        
        ROM[36] = 8'b01110100; // MOV A, #83h
        ROM[37] = 8'b10000011;
        
        ROM[38] = 8'b11110101; // MOV IE, A
        ROM[39] = 8'b10101000;
        
        ROM[40] = 8'b01110100; // MOV A, #10h
        ROM[41] = 8'b00010000;
        
        ROM[42] = 8'b11110101; // MOV TCON, A
        ROM[43] = 8'b10001000;
        
        ROM[44] = 8'b11110111; // HALT
        ROM[45] = 8'b10001000;
        
        ROM[46] = 8'b11110111; // HALT
        ROM[47] = 8'b10001000;
        
        //timer0 interrupt
        ROM[48] = 8'b11101000; // MOV A, R0
        ROM[49] = 8'b00000000;
        
        ROM[50] = 8'b00100100; // ADD A, #01h
        ROM[51] = 8'b00000001;
        
        ROM[52] = 8'b11111000; //MOV R0, A
        ROM[53] = 8'b00000000;
        
        ROM[54] = 8'b01110000; //JNZ #12h
        ROM[55] = 8'b00010010;
        
        ROM[56] = 8'b11101001; // MOV A, R1
        ROM[57] = 8'b00000000;
        
        ROM[58] = 8'b00100100; //ADD A, #01h
        ROM[59] = 8'b00000001;
        
        ROM[60] = 8'b11111001; //MOV R1, A
        ROM[61] = 8'b00000000;
        
        ROM[62] = 8'b10010100; //SUBB A, #04h
        ROM[63] = 8'b00000100;
        
        ROM[64] = 8'b01110000; //JNZ #08h
        ROM[65] = 8'b00001000;
        
        ROM[66] = 8'b01111001; //MOV R1, #00h
        ROM[67] = 8'b00000000;
        
        ROM[68] = 8'b11100101; //MOV A, PORT1
        ROM[69] = 8'b10010000;
        
        ROM[70] = 8'b00100100; //ADD A, #01h
        ROM[71] = 8'b00000001;
        
        ROM[72] = 8'b11110101; //MOV PORT1, A
        ROM[73] = 8'b10010000;
        
        ROM[74] = 8'b00110010; //RETI
        ROM[75] = 8'b00000000;
        
        ROM[76] = 8'b11110101; //MOV PORT1, A
        ROM[77] = 8'b10010000;
        
        ROM[76] = 8'b11110101; //MOV PORT1, A
        ROM[77] = 8'b10010000;
        
        ROM[78] = 8'b11110101; //MOV PORT1, A
        ROM[79] = 8'b10010000;
        
        ROM[80] = 8'b11110101; //MOV PORT1, A
        ROM[81] = 8'b10010000;
        
    end
       
    
    assign rom_byte = (rom_en == 1'b1) ? ROM[rom_addr] : 8'hzz;
    
    
                
endmodule
