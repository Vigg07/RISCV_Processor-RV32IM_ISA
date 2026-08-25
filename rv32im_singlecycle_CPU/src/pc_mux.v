`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: pc_mux
// Project Name: rv32im_single_cycle 
//////////////////////////////////////////////////////////////////////////////////

module pc_mux(
    
    input [1:0]  pc_sel,
    
    input [31:0] pc_plus4,
    input [31:0] branch_target,
    input [31:0] jal_target,
    input [31:0] jalr_target,
    
    output reg [31:0] next_pc 
    
    );
    
    always @(*) begin
        
        case(pc_sel)
        
            2'b00 : next_pc = pc_plus4;
            2'b01 : next_pc = branch_target;
            2'b10 : next_pc = jal_target;
            2'b11 : next_pc = jalr_target;
            
            default : next_pc = pc_plus4;
       
        endcase
    end
    
endmodule
