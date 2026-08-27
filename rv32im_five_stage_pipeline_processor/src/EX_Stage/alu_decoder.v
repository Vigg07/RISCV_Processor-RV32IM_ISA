`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Module Name: alu_decoder
// Project Name: rv32im_single_cycle 
//////////////////////////////////////////////////////////////////////////////////

module alu_decoder(
    input [1:0] alu_op,
    input [2:0] funct3,
    input [6:0] funct7,
    input [6:0] opcode,
    
    output reg [3:0] alu_ctrl
    );
    
    always @(*) begin
        case(alu_op)
        
            // LW, SW, AUIPC, JALR
            2'b00 : alu_ctrl = 4'b0000; 
            
            //B type 
            2'b01 : alu_ctrl = 4'b0001; 
            
            // R type and I type
            2'b10 : begin
                case(funct3)
                    3'b000: begin
                        //R type
                        if(opcode == 7'b0110011) begin     
                            case(funct7)
                                7'b0000000 : alu_ctrl = 4'b0000; // ADD
                                7'b0100000 : alu_ctrl = 4'b0001; // SUB
                                default: alu_ctrl = 4'b0000;
                            endcase
                        end
                        // I type
                        else
                            alu_ctrl = 4'b0000; // ADDI
                    end
                    
                    3'b001: alu_ctrl = 4'b0101; // SLL,SLLI
                    
                    3'b010: alu_ctrl = 4'b0110; // SLT,SLTI
                    
                    3'b011: alu_ctrl = 4'b0111; // SLTU,SLTIU
                    
                    3'b100: alu_ctrl = 4'b0100; // XOR,XORI
                    
                    3'b101: begin
                        case(funct7)
                            7'b0000000: alu_ctrl = 4'b1000; // SRL,SRLI
                            7'b0100000: alu_ctrl = 4'b1001; // SRA, SRAI
                            default: alu_ctrl = 4'b0000;
                        endcase
                    end
                    
                    3'b110: alu_ctrl = 4'b0011; // OR,ORI
                    
                    3'b111: alu_ctrl = 4'b0010; // AND,ANDI
                    
                    default : alu_ctrl = 4'b0000;
                    
                endcase
                end
            
            default: alu_ctrl = 4'b0000;
        
        endcase
    end
        
endmodule
