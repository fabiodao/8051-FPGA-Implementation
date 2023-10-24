`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2022 06:17:30 AM
// Design Name: 
// Module Name: datapath
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


module datapath(
    input clock,
    input reset,
    input [7:0] ram_rd_byte,  // byte read from RAM
    input [7:0] rom_byte,     // byte read from ROM, connected to the input of the Instruction Register
    input ram_rd_en_reg,      // Control signal that enables reading from RAM register bank
    input ram_wr_en_reg,      // Control signal that enables writing to RAM register bank
    input ram_rd_en_data,     // Control signal that enables reading from RAM data section
    input ram_wr_en_data,     // Control signal that enables writing to RAM data section
    input pc_inc,             // When this signal is high the program counter is incremented
    input pc_set,             // When this signal is high the value on pc_jmp_addr is added to the program counter
    input pc_isr,             // When this signal is high the program counter is set to the isr vector present in pc_jmp_addr
    input ir_load_high,       // When this signal is high the most significant byte of the IR is loaded with the byte fetched from ROM
    input ir_load_low,        // When this signal is high the least significant byte of the IR is loaded with the byte fetched from ROM
    input acc_load,           // Control signal to load the accumulator, connected to the accumulator write_en
    input stack_pop_pc,       // Control signal to pop the program counter from the stack when the RETI instruction is executed
    input ISR_req,            // Control signal to indicate that a interrupt needs to be serviced
    input [7:0] ISR_v,        // ISR address vector provided to the program counter when an interrupt is triggered
    input wire [15:0] jmp_addr_i, // Contains the program counter stored in the stack when the RETI instruction is executed
    input psw_load,           // Control signal to load the PSW register
    
    output wire [7:0] ram_rd_addr,  // Address to read from RAM
    output wire [7:0] ram_wr_addr,  // Address to write to RAM
    output wire [7:0] ram_wr_byte,  // Byte to write to RAM 
    output [7:0] opcode,            // Instruction opcode
    output wire [15:0] rom_addr,    // Program Counter output used to fetch instructions from ROM
    output wire [7:0] psw_out       // Output of PSW 
    );
    
    
    wire [15:0] pc_jmp_addr;       // Jump address provided to the program counter 
    wire [15:0] IR;                // Connected to the output of the Instruction Register
    wire [7:0] alu_out;            // Result from the ALU
    wire [7:0] acc_out;            // Output from ACC passed to the ALU as operand1
    wire [7:0] register_b;         // Passed to the ALU as the second operand
    
    wire psw_c;                    //carry bit
    wire psw_ac;                   //auxiliary carry bit
    wire psw_ov;                   //overflow bit
    wire psw_z;                    //zero bit
    wire psw_p;                    //parity bit
   
    //Instanciation of the program counter module
    program_counter pc(clock, reset, pc_inc, pc_set,pc_isr,pc_jmp_addr,rom_addr);
    
    //Instanciation of the instruction register module
    instruction_register ir(clock,reset,ir_load_high,ir_load_low,rom_byte,IR);
    
    //Instanciation of the ALU module
    arithmetic_logic_unit alu(reset,acc_out,register_b,opcode[7:0], psw_out,alu_out,psw_c,psw_ac,psw_ov,psw_p,psw_z);
    
    //Instanciation of the accumulator module
    acc acc(clock, reset, alu_out, acc_load, acc_out);
    
    //Instanciation of the PSW module
    psw psw(clock, reset, psw_c, psw_ac, psw_ov, psw_z, psw_p, psw_load, psw_out); 
 
    
    assign opcode = IR[15:8]; // Assigning the opcode to the most significant byte of IR
    
    
    assign ram_rd_addr = (ram_rd_en_data == 1'b1) ? IR[7:0] : 8'hzz; //When ram_rd_en_data is high the address to read from the RAM is the least significant byte of IR
    assign ram_wr_addr = (ram_wr_en_data == 1'b1) ? IR[7:0] : 8'hzz; //When ram_wr_en_data is high the address to write to the RAM is the least significant byte of IR
    assign register_b = (ram_rd_en_reg == 1'b1 || ram_rd_en_data == 1'b1) ? ram_rd_byte : IR[7:0]; // If the second operand of the alu is fetched from RAM the byte read from RAM is passed to the ALU, else the least significant byte of the IR is passed as second operand
    assign pc_jmp_addr = (pc_set == 1'b1 && pc_isr == 1'b0) ? IR[7:0] : (pc_isr == 1'b1 && ISR_req == 1'b1) ? ISR_v : (stack_pop_pc == 1'b1) ? jmp_addr_i : 8'hzz; // The jump address can be provided by the IR in the form of an offset, as an isr vector or as the return address of isr
    assign ram_wr_byte = (ram_wr_en_reg == 1'b1 && IR[15] == 0) ? IR[7:0] : acc_out; //If a register is being loaded with an immediate then the byte to write to the ROM is the least significant byte from IR, else, every other instruction writes the accumulator to the RAM 
     
endmodule
