`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: pc
// Project Name: rv32im_single_cycle 
/////////////////////////////////////////////////////////////////////////////////

module pc(
    input clk,rst,
    input [31:0] next_pc,
    output reg [31:0] pc
    );
    
    always @(posedge clk)
    begin
        if(rst)
            pc <= 32'd0;
        else
            pc <= next_pc;
    end
       
endmodule
