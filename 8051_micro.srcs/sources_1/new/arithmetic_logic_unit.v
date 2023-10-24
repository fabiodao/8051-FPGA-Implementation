`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2022 01:57:29 PM
// Design Name: 
// Module Name: arithmetic_logic_unit
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


module arithmetic_logic_unit(
    input reset,
    input [7:0]operand1,   //First operand connected to the output of the accumulator, as all operations implemented use the accumulator as source operand
    input [7:0]operand2,   //Second operand
    input [7:0]opcode,     //Instruction opcode
    input [7:0] PSW,       //PSW register
    output [7:0] result_o,  //Result from operation
    output psw_c,           //carry bit
    output psw_ac,          //auxiliary carry bit
    output psw_ov,          //overfow bit
    output psw_p,           //parity bit
    output psw_z            //zero bit
    );
    
    
    `include "opcodes.v"
    
    reg [8:0] result;  //register to store the result of the operation, the ninth bit is used to store the carry bit
    
    initial begin
        result = 9'b000000000;
    end
   
    assign result_o = result[7:0];  //assign the 8 least significant bits of the result to result_o
    
    assign psw_c = result[8];   //The carry bit is assigned the value of the ninth bit of the result of an arithmetic operation.
    assign psw_ac = result[4];  //The auxiliary carry is set when there's a carry from bit 3 to bit 4 of the result
    assign psw_ov = result[8]&&~result[7] || result[7]&&~result[8]; //The overflow bit is set when the result is higher than 128 or smaller than -128
    assign psw_p =  result[7:0]%2; //The parity bit is set when the result is odd
    assign psw_z = ~(result[7] | result[6] | result[5] | result[4] | result[3] | result[2] | result[1] | result[0]); //The zero bit is set when the result is zero

     
       
    always @(*)
    begin
        if(reset)
        begin
            result = 9'b000000000;
        end
            casex(opcode)
           
                `MOV_AI : begin  
                    result[7:0] = operand2;  //result is connected to the input of the accumulator, accumulator is loaded with the value from operand2
                    end 
                `MOV_AR : begin   //result is connected to the input of the accumulator, accumulator is loaded with the value from operand2
                    result[7:0] = operand2;
                    end 
                `MOV_AD: begin
                    result[7:0] = operand2;
                    end
                `ADD : begin
                    result = operand1 + operand2; 
                    end
                `SUBB : begin
                    result = operand1 - operand2;
                    end
                `ANL: begin
                    result = operand1 & operand2;
                    end
                `ORL:begin
                    result = operand1 | operand2;
                    end
                `XRL:begin
                    result = operand1 ^ operand2;
                    end
                 default:
                    result=result;
            endcase
                     
        end    
endmodule
