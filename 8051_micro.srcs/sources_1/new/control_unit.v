`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2022 06:21:44 PM
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input clock,
    input reset,
    input [7:0] opcode,             //Instruction opcode
    input ISR_req,                  //Control signal is high when a interrupt needs to be serviced
    input [7:0] PSW,                //PSW register
    output ram_rd_en_reg,           // Control signal that enables reading from RAM register bank
    output ram_wr_en_reg,           // Control signal that enables writing to RAM register bank
    output [2:0] ram_reg_in_sel,    // Selection signal for register to write to
    output [2:0] ram_reg_out_sel,   // Selection signal for register to read from
    output ram_rd_en_data,          // Control signal that enables reading from RAM data section
    output ram_wr_en_data,          // Control signal that enables writing to RAM data section
    output rom_en,                  // Control signal to fetch byte from ROM
    output pc_inc,                  // When this signal is high the program counter is incremented
    output pc_set,                  // When this signal is high the value on pc_jmp_addr is added to the program counter
    output pc_isr,                  // When this signal is high the program counter is set to the isr vector present in pc_jmp_addr
    output ir_load_high,            // When this signal is high the most significant byte of the IR is loaded with the byte fetched from ROM
    output ir_load_low,             // When this signal is high the least significant byte of the IR is loaded with the byte fetched from ROM
    output acc_load,                // Control signal to load the accumulator
    output stack_push_pc,           // Control signal to push the program counter to the stack when the interrupt is serviced
    output stack_pop_pc,            // Control signal to pop the program counter from the stack when the RETI instruction is executed
    output psw_load                 // Control signal to load the PSW
    );
   
    `include "opcodes.v"

    
    reg [4:0] state;
        
    //=========== Internal Constants =====================
    parameter s_start   = 5'b00000, 
              s_fetch_1 = 5'b00001,     //state to fetch the most significant byte of the instruction to be executed
              s_fetch_2 = 5'b00010,     //state to fetch the least significant byte of the instruction to be executed
              s_decode  = 5'b00011,     //state to decode the opcode
              s_mov_ri  = 5'b00100,     //state to execute the instruction to move an immediate to a register
              s_mov_ai  = 5'b00101,     //state to execute the instruction to move an immediate to the accumulator
              s_mov_ar  = 5'b00110,     //state to execute the instruction to move the value on register to accumulator
              s_add_ai  = 5'b00111,     //state to execute the instruction to add an immediate with the accumulator
              s_mov_ra  = 5'b01000,     //state to execute the instruction to move the value on the accumulator to a register
              s_subb_ai = 5'b01001,     //state to execute the instruction to subtract an immediate with the accumulator  
              s_orl_ai  = 5'b01011,     //state to execute the instruction to or an immediate with the accumulator
              s_anl_ai  = 5'b01101,     //state to execute the instruction to and an immediate with the accumulator
              s_xrl_ai  = 5'b01111,     //state to execute the instruction to xor an immediate with the accumulator
              s_jnz     = 5'b10001,     //state to execute the jump if not zero instruction
              s_jz      = 5'b10010,     //state to execute the jump if zero instruction
              s_sjmp    = 5'b10011,     //state to execute the short jump instruction
              s_jnc     = 5'b10100,     //state to execute the jump if carry is zero instruction
              s_mov_ad  = 5'b10101,     //state to execute the instruction to move a direct to the accumulator
              s_mov_dr  = 5'b10110,     //state to execute the instruction to move a register to a direct
              s_reti    = 5'b10111,     //state to execute the instruction to return from isr routine
              s_mov_da  = 5'b11000,     //state to execute the instruction to move the accumulator to a direct
              s_halt    = 5'b11111;
    //====================================================

  
initial begin
    state <= s_start;
end
   
assign rom_en = (state == s_fetch_1 || state == s_fetch_2) ? 1'b1 : 1'b0;
assign pc_inc = (state == s_fetch_1 || state == s_fetch_2) ? 1'b1 : 1'b0;

assign ir_load_high = (state == s_fetch_1) ? 1'b1 : 1'b0;
assign ir_load_low = (state == s_fetch_2) ? 1'b1 : 1'b0;

assign ram_wr_en_reg = (state == s_mov_ri || state == s_mov_ra) ? 1'b1 : 1'b0;
assign ram_reg_in_sel = (state == s_mov_ri || state == s_mov_ra) ? opcode[2:0] : 3'bzzz;

assign ram_rd_en_reg = (state == s_mov_ar || state == s_mov_dr) ? 1'b1 : 1'b0;
assign ram_reg_out_sel = (state == s_mov_ar || state == s_mov_dr) ? opcode[2:0] : 3'bzzz;
assign ram_rd_en_data = (state == s_mov_ad) ? 1'b1 : 1'b0;
assign ram_wr_en_data = (state == s_mov_dr || state == s_mov_da) ? 1'b1 : 1'b0;

assign acc_load = (state == s_xrl_ai || state == s_orl_ai || state == s_anl_ai ||state == s_subb_ai || state == s_mov_ai || state == s_mov_ad || state == s_mov_ar || state == s_add_ai) ? 1'b1 : 1'b0;

assign pc_set = ((state == s_sjmp) || (state == s_jnz && ~PSW[1]) || (state == s_jz && PSW[1]) || (state == s_jnc && ~PSW[7]) || state == s_halt ) ? 1'b1 : 1'b0;

assign pc_isr = ((state == s_start && ISR_req == 1'b1) || state == s_reti || state == s_halt) ? 1'b1 : 1'b0;

assign stack_push_pc = (state == s_start && ISR_req) ? 1'b1 : 1'b0;

assign stack_pop_pc = (state == s_reti) ? 1'b1 : 1'b0;

assign psw_load = acc_load;

always @ (posedge clock)

begin : FSM
	if (reset == 1'b1) begin // reset
		state <=  s_start;
	end
	else begin
		case(state)
			s_start :
			    if(reset != 1'b1)
			    begin
				    state <= s_fetch_1;
				end
				
			s_fetch_1:
				state <= s_fetch_2;
		    s_fetch_2:
		        state <= s_decode;
			s_decode :
                casex(opcode) 
				    `MOV_RI: 
				        state <= s_mov_ri;
				    `MOV_DR:
				        state <= s_mov_dr;
				    `MOV_AD:
				        state <= s_mov_ad;
				    `MOV_RA:
				        state <= s_mov_ra;
                    `SJMP:
                        state <= s_sjmp;
                    `MOV_AI: 
                        state <= s_mov_ai;
                    `MOV_AR: 
                        state <= s_mov_ar;
                    `MOV_DA:
                        state <= s_mov_da;
                    `ADD_AI:
                        state <= s_add_ai;
                    `SUBB_AI:
                        state <= s_subb_ai;
                    `ORL_AI:
                        state <= s_orl_ai;
                    `ANL_AI:
                        state <= s_anl_ai;
                    `XRL_AI:
                        state <= s_xrl_ai;
                    `JNZ:
                        state <= s_jnz;
                    `JZ:
                        state <= s_jz;
                    `JNC:
                        state <= s_jnc;
                    `RETI:
                        state <= s_reti;
                    `HALT:
                        state <= s_halt;
                    default : 
			            state <= s_fetch_1;
                 endcase
            s_mov_ri:
                state <= s_start;
            s_mov_ai:
                state <= s_start;
            s_mov_ad:
                state <= s_start;
            s_mov_dr:
                state <= s_start;
            s_mov_ar:
                state <= s_start;
            s_mov_da:
                state <= s_start;
            s_add_ai:
                state <= s_start;
            s_mov_ra:
                state <= s_start;
            s_subb_ai:
                state <= s_start;
            s_orl_ai:
                state <= s_start;
            s_anl_ai:
                state <= s_start;
            s_xrl_ai:
                state <= s_start;
            s_jnz:
                state <= s_start;
            s_jz:
                state <= s_start;
            s_sjmp:
                state <= s_start;
            s_jnc:
                state <= s_start;
            s_reti:
                state <= s_start;
            s_halt:
                state <= s_start;         
            default : 
			    state <= s_start;
		endcase
	end	
end
   
endmodule