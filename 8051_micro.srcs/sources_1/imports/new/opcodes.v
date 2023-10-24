
`ifndef _OPCODES_V_
`define _OPCODES_V_
// instruction set

//opcode [7:1]
`define MOV_RI  8'b0111_1xxx //done
`define MOV_AR  8'b1110_1xxx //done
`define MOV_DR  8'b1000_1xxx //done
`define MOV_RA  8'b1111_1xxx //done

//opcodes [7:0]
`define MOV_AI  8'b0111_0100 //done
`define MOV_AD  8'b1110_0101 //done
`define MOV_DA  8'b1111_0101 //done
`define ADD_AI  8'b0010_0100 //done
`define SUBB_AI 8'b1001_0100 //done
`define ORL_AI  8'b0100_0100 //done
`define ANL_AI  8'b0101_0100 //done
`define XRL_AI  8'b0110_0100 //done
`define SJMP    8'b1000_0000 //done
`define JNZ     8'b0111_0000 //done
`define JZ      8'b0110_0000 
`define JNC     8'b1010_0000
`define RETI    8'b0011_0010
`define HALT    8'b1111_0111

//ALU instructions
`define ADD     8'b0010_01xx
`define SUBB    8'b1001_01xx
`define ANL     8'b0101_01xx
`define ORL     8'b0100_01xx
`define XRL     8'b0110_01xx


`endif