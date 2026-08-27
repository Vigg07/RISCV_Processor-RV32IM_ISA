`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: mem_wb
// Project Name: rv32im_5stage_pipeline
//////////////////////////////////////////////////////////////////////////////////

module mem_wb(
    
    input clk,
    input rst,
    
    input [2:0]  wb_sel_in,
    input        is_mul_div_in,
    input [31:0] alu_result_in,
    input [31:0] mul_div_result_in,
    input [31:0] imm_in,
    input [31:0] mem_data_in,
    input [31:0] auipc_data_in,
    input [31:0] pc_plus4_in,
    input [4:0]  rd_in,
    input        reg_write_in,
    
    output reg [2:0]  wb_sel_out,
    output reg        is_mul_div_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] mul_div_result_out,
    output reg [31:0] imm_out,
    output reg [31:0] mem_data_out,
    output reg [31:0] auipc_data_out,
    output reg [31:0] pc_plus4_out,
    output reg [4:0]  rd_out,
    output reg        reg_write_out
   
    );
    
    always @(posedge clk)
    begin
        
        if(rst) begin
            wb_sel_out         <= 3'b0;
            is_mul_div_out     <= 1'b0;
            alu_result_out     <= 32'b0;
            mul_div_result_out <= 32'b0;
            imm_out            <= 32'b0;
            mem_data_out       <= 32'b0;
            auipc_data_out     <= 32'b0;
            pc_plus4_out       <= 32'b0;
            rd_out             <= 5'b0;
            reg_write_out      <= 1'b0;
        end
        else begin
            wb_sel_out         <= wb_sel_in;
            is_mul_div_out     <= is_mul_div_in;
            alu_result_out     <= alu_result_in;
            mul_div_result_out <= mul_div_result_in;
            imm_out            <= imm_in;
            mem_data_out       <= mem_data_in;
            auipc_data_out     <= auipc_data_in;
            pc_plus4_out       <= pc_plus4_in;
            rd_out             <= rd_in;
            reg_write_out      <= reg_write_in;
        end
    end
    
endmodule
