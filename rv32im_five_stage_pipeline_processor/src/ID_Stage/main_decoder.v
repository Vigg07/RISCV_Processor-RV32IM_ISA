`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: main_decoder
// Project Name: rv32im_single_cycle
//////////////////////////////////////////////////////////////////////////////////

module main_decoder(
    
    input [6:0] opcode,
    input [6:0] funct7,
    
    output reg reg_write,
    output reg alu_src,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg jump,
    output reg [1:0] alu_op,
    output reg [2:0] wb_sel,
    output reg is_mul_div
    
    );
    
    
    always @(*) begin
        
        reg_write  = 1'b0;
        alu_src    = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        branch     = 1'b0;
        jump       = 1'b0;
        alu_op     = 2'b00;
        wb_sel     = 3'b000;
        is_mul_div = 1'b0;
        
        case(opcode)
        
        // R type
        7'b0110011 :
            begin
                reg_write = 1'b1;
                alu_src = 1'b0;
                alu_op = 2'b10;
                wb_sel = 3'b000;
                
                if(funct7 == 7'b0000001)
                    is_mul_div = 1'b1;
            end
            
        // I type
        7'b0010011 :
            begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_op = 2'b10;
                wb_sel = 3'b000;
            end
       
        // B type
        7'b1100011 :
            begin
                branch = 1'b1;
                alu_op = 2'b01;
            end
            
        // Load
        7'b0000011 :
            begin
                mem_read = 1'b1;
                reg_write = 1'b1;
                alu_src = 1'b1;
                wb_sel = 3'b001;
                alu_op = 2'b00;
            end
            
        // S type
        7'b0100011 :
            begin   
                mem_write = 1'b1;
                alu_src = 1'b1;
                alu_op = 2'b00;
            end
            
        // JAL
        7'b1101111:
            begin
                reg_write = 1'b1;
                jump = 1'b1;
                wb_sel = 3'b100;
            end
            
        // JALR
        7'b1100111 :
            begin
                reg_write = 1'b1;
                jump = 1'b1;
                wb_sel = 3'b100;
                alu_src = 1'b1;
                alu_op = 2'b00;
            end
            
        // AUIPC
        7'b0010111:
            begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_op = 2'b00;
                wb_sel = 3'b011;
            end
        
        // LUI
        7'b0110111:
            begin
                reg_write = 1'b1;
                wb_sel = 3'b010;
            end
       
        default:
            begin
                reg_write  = 0;
                alu_src    = 0;
                mem_read   = 0;
                mem_write  = 0;
                wb_sel = 3'b000;
                branch     = 0;
                jump       = 0;
                alu_op     = 2'b00;
                is_mul_div = 1'b0;
            end
        endcase
    end
      
endmodule
