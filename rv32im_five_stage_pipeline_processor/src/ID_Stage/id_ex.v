`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: id_ex
// Project Name: rv32im_5stage_pipeline 
//////////////////////////////////////////////////////////////////////////////////

module id_ex(

    input clk,
    input rst,
    
    input stall,
    input flush,
    input [31:0] pc_in,
    input [31:0] pc_plus4_in,
    input [31:0] imm_id,
    input [6:0] opcode_in,
    input [6:0] funct7_in,
    input [2:0] funct3_in,
    
    input reg_write_in,
    input alu_src_in,
    input mem_read_in,
    input mem_write_in,
    input branch_in,
    input jump_in,
    input [1:0] alu_op_in,
    input [2:0] wb_sel_in,
    input is_mul_div_in,
    input [31:0] auipc_data_in,
    
    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [4:0] rd_in,
    
    input [31:0] read_data1_in,
    input [31:0] read_data2_in,
    
    output reg [31:0] pc_out,
    output reg [31:0] pc_plus4_out,
    output reg [31:0] imm_ex,
    output reg [6:0] opcode_out,
    output reg [6:0] funct7_out,
    output reg [2:0] funct3_out,
    
    output reg reg_write_out,
    output reg alu_src_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg branch_out,
    output reg jump_out,
    output reg [1:0] alu_op_out,
    output reg [2:0] wb_sel_out,
    output reg is_mul_div_out,
    output reg [31:0] auipc_data_out,
      
    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,
    
    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out    
    
    );
    
    always @(posedge clk)
    begin
        if(rst)
        begin
            pc_out       <= 32'b0;
            pc_plus4_out <= 32'b0;
            imm_ex       <= 32'b0;
            opcode_out   <= 7'b0;
            funct7_out   <= 7'b0;
            funct3_out   <= 3'b0;
            
            reg_write_out  <= 1'b0;
            alu_src_out    <= 1'b0;
            mem_read_out   <= 1'b0;
            mem_write_out  <= 1'b0;
            branch_out     <= 1'b0;
            jump_out       <= 1'b0;
            alu_op_out     <= 2'b0;
            wb_sel_out     <= 3'b0;
            is_mul_div_out <= 1'b0;
            auipc_data_out <= 32'b0;
            
            rs1_out <= 5'b0;
            rs2_out <= 5'b0;
            rd_out  <= 5'b0;
            
            read_data1_out <= 32'b0;
            read_data2_out <= 32'b0;
        end
        else if(flush) begin
            pc_out       <= 32'b0;
            pc_plus4_out <= 32'b0;
            imm_ex       <= 32'b0;
            opcode_out   <= 7'b0;
            funct7_out   <= 7'b0;
            funct3_out   <= 3'b0;
            
            reg_write_out  <= 1'b0;
            alu_src_out    <= 1'b0;
            mem_read_out   <= 1'b0;
            mem_write_out  <= 1'b0;
            branch_out     <= 1'b0;
            jump_out       <= 1'b0;
            alu_op_out     <= 2'b0;
            wb_sel_out     <= 3'b0;
            is_mul_div_out <= 1'b0;
            auipc_data_out <= 32'b0;
            
            rs1_out <= 5'b0;
            rs2_out <= 5'b0;
            rd_out  <= 5'b0;
            
            read_data1_out <= 32'b0;
            read_data2_out <= 32'b0;
        end
        else if(!stall) begin
            pc_out       <= pc_in;
            pc_plus4_out <= pc_plus4_in;
            imm_ex       <= imm_id;
            opcode_out   <= opcode_in;
            funct7_out   <= funct7_in;
            funct3_out   <= funct3_in;
            
            reg_write_out  <= reg_write_in;
            alu_src_out    <= alu_src_in;
            mem_read_out   <= mem_read_in;
            mem_write_out  <= mem_write_in;
            branch_out     <= branch_in;
            jump_out       <= jump_in;
            alu_op_out     <= alu_op_in;
            wb_sel_out     <= wb_sel_in;
            is_mul_div_out <= is_mul_div_in;
            auipc_data_out <= auipc_data_in;
            
            rs1_out <= rs1_in;  
            rs2_out <= rs2_in;
            rd_out  <= rd_in;
            
            read_data1_out <= read_data1_in;
            read_data2_out <= read_data2_in;
        end
        else begin
            reg_write_out  <= 1'b0;
            mem_read_out   <= 1'b0;
            mem_write_out  <= 1'b0;
            branch_out     <= 1'b0;
            jump_out       <= 1'b0;
            is_mul_div_out <= 1'b0;
            rd_out         <= 5'b0;
            alu_src_out    <= 1'b0;
            alu_op_out     <= 2'b0;
            wb_sel_out     <= 3'b0;    
                        
        end
    end      

endmodule
