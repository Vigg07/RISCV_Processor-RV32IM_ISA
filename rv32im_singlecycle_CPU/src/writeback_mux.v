`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: writeback_mux
// Project Name: rv32im_single_cycle 
//////////////////////////////////////////////////////////////////////////////////

module writeback_mux(

    input [2:0] wb_sel,
    input       is_mul_div,
    
    input [31:0] mul_div_result,
    input [31:0] alu_result,
    input [31:0] imm_out,
    input [31:0] mem_data,
    input [31:0] auipc_data,
    input [31:0] pc_plus4,
    
    output reg [31:0] writeback_data

    );
    
    always @(*) begin
        
        if(is_mul_div)
            writeback_data = mul_div_result; // M Instructions
        else begin
            case(wb_sel)
            
                3'b000 : writeback_data = alu_result; // ADD, SUB, SLT, SLTU, AND, OR, XOR, SRA...
                3'b001 : writeback_data = mem_data;   // LW
                3'b010 : writeback_data = imm_out;    // LUI
                3'b011 : writeback_data = auipc_data; // AUIPC
                3'b100 : writeback_data = pc_plus4;   // JAL, JALR
                
                default: writeback_data = 32'b0;
            endcase
        end
    end     
endmodule
