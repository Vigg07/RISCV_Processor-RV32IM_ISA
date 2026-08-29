`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: imm_gen
// Project Name: rv32im_single_cycle 
//////////////////////////////////////////////////////////////////////////////////

module imm_gen(
    input [31:0] instruction,
    output reg [31:0] imm_out
    );
    
    wire [6:0] opcode;
    assign opcode = instruction[6:0];
    
    always @(*)begin
        case(opcode)
        
        // I type-a
        7'b0010011 : // ADDI,SLTI...
            begin
                if(instruction[14:12] == 3'b001 || instruction[14:12] == 3'b101)
                    imm_out = {{27{1'b0}},instruction[24:20]};
                else
                    imm_out = {{20{instruction[31]}},instruction[31:20]};
            end
        
        //I type-b
        7'b0000011, // LW,LH...
        7'b1100111 : // JALR 
            imm_out = {{20{instruction[31]}},instruction[31:20]};
        
        // U type
        7'b0110111, // LUI
        7'b0010111 :// AUIPC
            imm_out = {instruction[31:12], 12'b0};
        
        // B type
        7'b1100011 : 
            imm_out = {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
        
        // S type
        7'b0100011:
            imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            
        // J Type     
        7'b1101111:  
            imm_out = {{11{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0};
        
        default: 
            imm_out = 32'b0;
            
        endcase
    end
        
endmodule

