`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: load_use_hazard_unit
// Project Name: rv32im_5stage_pipeline 
//////////////////////////////////////////////////////////////////////////////////

module load_use_hazard_unit(
    input mem_read_ex,
    input [4:0] rd_ex,
    
    input [4:0] rs1_id,
    input [4:0] rs2_id,
    
    output reg stall
    );
    
    always @(*) begin
        
        if((mem_read_ex == 1'b1) && (rd_ex != 5'b0) && ((rs1_id == rd_ex) || (rs2_id == rd_ex)) )
            begin
                stall = 1'b1;
            end
        else begin
            stall = 1'b0;
        end
    end
       
endmodule
