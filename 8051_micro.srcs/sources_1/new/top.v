`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2022 06:16:30 AM
// Design Name: 
// Module Name: top
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


module top(
    input clock,
    input reset,
    input pb_1,
    output [7:0] PORT1_o
    );

wire [7:0] opcode; // wire because is gonna be connected between the datapath and the controlunit
wire [15:0] rom_addr;
wire [7:0] ram_rd_addr;
wire [7:0] ram_wr_addr;
wire [7:0] ram_rd_byte;
wire [7:0] ram_wr_byte;
wire [7:0] rom_byte;
wire [2:0] ram_reg_in_sel;
wire [2:0] ram_reg_out_sel;
wire [7:0] acc_copy;
wire data_vld;
wire [7:0] tmod;
wire [7:0] tmod_in;
wire [7:0] tcon_in;
wire [7:0] tcon;
wire [7:0] TH0_i;
wire [7:0] TL0_i;
wire [15:0] pc_reti_in;
wire [15:0] jmp_addr_i;
wire [7:0] psw_out;
wire [7:0] ISR_v;
wire [7:0] IE_i;

 
control_unit ctrl_unit(
	
    .clock(clock),
    .reset(reset),
    .opcode(opcode),
    //.TI0_i(TI0_i),
    .ISR_req(ISR_req),
    .PSW(psw_out),
    .ram_rd_en_reg(ram_rd_en_reg),
    .ram_wr_en_reg(ram_wr_en_reg),
    .ram_reg_in_sel(ram_reg_in_sel),
    .ram_reg_out_sel(ram_reg_out_sel),
    .ram_rd_en_data(ram_rd_en_data),
    .ram_wr_en_data(ram_wr_en_data),
    .rom_en(rom_en),
    .pc_inc(pc_inc),
    .pc_set(pc_set),
    .pc_isr(pc_isr),
    .ir_load_high(ir_load_high),
    .ir_load_low(ir_load_low),
    .acc_load(acc_load),
    .stack_push_pc(stack_push_pc),
    .stack_pop_pc(stack_pop_pc),
    .psw_load(psw_load)
);

datapath data_path(

    .clock(clock),
    .reset(reset),
    .ram_rd_byte(ram_rd_byte),
    .rom_byte(rom_byte),
    .ram_rd_en_reg(ram_rd_en_reg),
    .ram_wr_en_reg(ram_wr_en_reg),
    .ram_rd_en_data(ram_rd_en_data),
    .ram_wr_en_data(ram_wr_en_data),
    .pc_inc(pc_inc),
    .pc_set(pc_set),
    .pc_isr(pc_isr),
    .ir_load_high(ir_load_high),
    .ir_load_low(ir_load_low),
    .acc_load(acc_load),
    .stack_pop_pc(stack_pop_pc),
    .ISR_req(ISR_req),
    .ISR_v(ISR_v),
    .jmp_addr_i(jmp_addr_i),
    .psw_load(psw_load),
    .ram_rd_addr(ram_rd_addr),
    .ram_wr_addr(ram_wr_addr),
    .ram_wr_byte(ram_wr_byte),
    .opcode(opcode),
    .rom_addr(rom_addr),
    .psw_out(psw_out)

);

ram ram(
    .clock(clock),
    .reset(reset),
    .ram_rd_en_reg(ram_rd_en_reg),
    .ram_wr_en_reg(ram_wr_en_reg),
    .ram_reg_in_sel(ram_reg_in_sel),
    .ram_reg_out_sel(ram_reg_out_sel),
    .ram_rd_en_data(ram_rd_en_data),
    .ram_wr_en_data(ram_wr_en_data),
    .ram_rd_addr(ram_rd_addr),
    .ram_wr_addr(ram_wr_addr),
    .ram_wr_byte(ram_wr_byte),
    .stack_push_pc(stack_push_pc),
    .stack_pop_pc(stack_pop_pc),
    .TF0_i(TF0_i),
    .pc_reti_in(rom_addr),
    .ram_rd_byte(ram_rd_byte),
    .tcon(tcon),
    .tmod(tmod),
    .TL0(TL0_i),
    .TH0(TH0_i),
    .jmp_addr_o(jmp_addr_i),
    .PORT1_o(PORT1_o),
    .IE_o(IE_i)
);

rom rom(
    .reset(reset),
    .rom_en(rom_en),
    .rom_addr(rom_addr),
    .rom_byte(rom_byte)
);

timer0  TIMER0(
    .clock(clock),
    .reset(reset),
    .tmod(tmod),
    .tcon(tcon),
    .TH0_i(TH0_i),
    .TL0_i(TL0_i),
    .TF0_clr(TF0_clr),
    .TF0_o(TF0_i)
    );
    
interrupt_controller isr_ctrl(
    .clock(clock),
    .reset(reset),
    .stack_push_pc(stack_push_pc),
    .IE_i(IE_i),
    .TCON_i(tcon),
    .EI0_i(EI0_i),
    .TF0_clr(TF0_clr),
    .ISR_v(ISR_v),
    .ISR_req(ISR_req)
    );

Button_debounce EISR(
    .clock(clock),
    .reset(reset),
    .button(pb_1),
    .button_out(EI0_i)
    );
    

endmodule
