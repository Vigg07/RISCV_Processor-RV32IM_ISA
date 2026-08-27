`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: pc_target_gen
// Project Name: rv32im_single_cycle
//////////////////////////////////////////////////////////////////////////////////

module pc_target_gen(
    
    input [31:0] pc,
    input [31:0] imm_out,
    input [31:0] rs1_data,
    
    output [31:0] branch_target,
    output [31:0] jal_target,
    output [31:0] jalr_target,
    output [31:0] auipc_data,
    output [31:0] pc_plus4
    
    );
    
    assign pc_plus4      = pc + 32'd4;
    assign branch_target = pc + imm_out;
    assign jal_target    = pc + imm_out;
    assign auipc_data    = pc + imm_out;
    assign jalr_target   = (rs1_data + imm_out) & 32'hFFFFFFFE;
    
endmodule
