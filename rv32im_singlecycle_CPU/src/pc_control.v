`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: pc_control
// Project Name: rv32im_single_cycle 
//////////////////////////////////////////////////////////////////////////////////

module pc_control(
    
    input jump,
    input branch_taken,
    input [6:0] opcode,
    
    output reg [1:0] pc_sel
    
    );

    always @(*) begin
        
        pc_sel = 2'b00; // Default : pc+4
        
        if(branch_taken)
            pc_sel = 2'b01;
        else if(jump && (opcode == 7'b1101111)) // JAL
            pc_sel = 2'b10;
        else if(jump && (opcode == 7'b1100111)) // JALR
            pc_sel = 2'b11;
    end
       
endmodule
