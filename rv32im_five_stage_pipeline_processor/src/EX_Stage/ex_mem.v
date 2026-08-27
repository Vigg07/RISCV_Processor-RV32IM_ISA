`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: ex_mem
// Project Name: rv32im_5stage_pipeline
//////////////////////////////////////////////////////////////////////////////////

module ex_mem(

    input clk,
    input rst,

    input [31:0] alu_result_in,
    input [31:0] read_data2_in,
    input [31:0] mul_div_result_in,

    input [31:0] imm_in,
    input [31:0] auipc_data_in,
    input [31:0] pc_plus4_in,
    input        is_mul_div_in,

    input        mem_read_in,
    input        mem_write_in,

    input        reg_write_in,
    input [2:0]  wb_sel_in,
    input [4:0]  rd_in,

    output reg [31:0] alu_result_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] mul_div_result_out,
    
    output reg [31:0] imm_out,
    output reg [31:0] auipc_data_out,
    output reg [31:0] pc_plus4_out,
    output reg        is_mul_div_out,

    output reg        mem_read_out,
    output reg        mem_write_out,

    output reg        reg_write_out,
    output reg [2:0]  wb_sel_out,
    output reg [4:0]  rd_out

);

    always @(posedge clk)
    begin
        
        if(rst) begin
            alu_result_out     <= 32'b0;
            read_data2_out     <= 32'b0;
            mul_div_result_out <= 32'b0;
            mem_read_out       <= 1'b0;
            mem_write_out      <= 1'b0;
            reg_write_out      <= 1'b0;
            wb_sel_out         <= 3'b0;
            rd_out             <= 5'b0;
            imm_out            <= 32'b0;
            auipc_data_out     <= 32'b0;
            pc_plus4_out       <= 32'b0;
            is_mul_div_out     <= 1'b0;  
        end
        else begin
            alu_result_out     <= alu_result_in;
            read_data2_out     <= read_data2_in;
            mul_div_result_out <= mul_div_result_in;
            mem_read_out       <= mem_read_in;
            mem_write_out      <= mem_write_in;
            reg_write_out      <= reg_write_in;
            wb_sel_out         <= wb_sel_in;
            rd_out             <= rd_in;
            imm_out            <= imm_in;
            auipc_data_out     <= auipc_data_in;
            pc_plus4_out       <= pc_plus4_in;
            is_mul_div_out     <= is_mul_div_in;        
        end
    end
    
endmodule
            
            
