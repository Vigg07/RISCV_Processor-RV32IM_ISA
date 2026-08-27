`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Module Name: data_mem
// Project Name: rv32im_single_cycle 
//////////////////////////////////////////////////////////////////////////////////

module data_mem(
    input clk,

    input mem_read,
    input mem_write,

    input [31:0] address,
    input [31:0] write_data,
    
    output reg [31:0] read_data        
    );
    
    reg [31:0] memory [0:255];
    
    always @(*) begin
        if(mem_read)
            read_data = memory[address[31:2]];
        else    
            read_data = 32'b0;
    end
    
    always @(posedge clk) begin
        if(mem_write)
            memory[address[31:2]] <= write_data;
    end
    
    
endmodule
