`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: alu_mux
// Project Name: rv32im_single_cycle 
//////////////////////////////////////////////////////////////////////////////////

module alu_mux(
    
    input [31:0] read_data2,
    input [31:0] imm,
    input        alu_src,
    
    output [31:0] alu_b
  
    );
    
    assign alu_b = (alu_src) ? imm : read_data2;              
    
endmodule
