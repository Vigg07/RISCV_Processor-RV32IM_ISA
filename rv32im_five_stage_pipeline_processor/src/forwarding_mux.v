`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: forwarding_mux
// Project Name: rv32im_5stage_pipeline
//////////////////////////////////////////////////////////////////////////////////

module forwarding_mux(
       
    input [31:0] reg_data,
    input [31:0] alu_result_mem,
    input [31:0] mul_div_result_mem,
    input [31:0] writeback_data_wb,
    input        is_mul_div_mem,
    input [1:0]  forward,
    
    output reg [31:0] alu_input
    
    );
    
    always @(*) begin   
        
        case(forward)
            
            2'b00 : alu_input = reg_data;
            
            2'b01 : begin
                if(is_mul_div_mem)
                    alu_input = mul_div_result_mem;
                else
                    alu_input = alu_result_mem;
            end
            
            2'b10 : alu_input = writeback_data_wb;
            
            default : alu_input = reg_data;
            
        endcase
    end
    
endmodule
