`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: instr_mem
// Project Name: rv32im_single_cycle
//////////////////////////////////////////////////////////////////////////////////

module instr_mem(
    input [31:0] addr,
    output [31:0] instruction
    );
    
    reg [31:0] memory [0:255];
    
    assign instruction = memory[addr[31:2]];
    
endmodule
