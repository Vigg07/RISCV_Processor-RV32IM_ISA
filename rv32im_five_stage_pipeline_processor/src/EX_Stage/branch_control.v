`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: branch_control
// Project Name: rv32im_single_cycle
//////////////////////////////////////////////////////////////////////////////////

module branch_control(

    input        branch,
    input [2:0]  funct3,
    input [31:0] a,b,
    
    output reg   branch_taken
    );
    
    always @(*) begin

        if(branch == 1'b0)
            branch_taken = 1'b0;
            
        else begin
            case(funct3)
                
                3'b000 : branch_taken = (a == b) ? 1'b1 : 1'b0; // BEQ
                
                3'b001 : branch_taken = (a != b) ? 1'b1 : 1'b0; // BNE
                
                3'b100 : branch_taken = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0; // BLT
                
                3'b101 : branch_taken = ($signed(a) >= $signed(b)) ? 1'b1 : 1'b0; // BGE
                
                3'b110 : branch_taken = (a < b) ? 1'b1 : 1'b0; // BLTU
                
                3'b111 : branch_taken = (a >= b) ? 1'b1 : 1'b0; // BGEU
                
                default: branch_taken = 1'b0;
                
            endcase 
        end         
    end
endmodule
