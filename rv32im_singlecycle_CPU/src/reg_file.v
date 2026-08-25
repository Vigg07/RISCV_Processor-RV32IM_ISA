`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: reg_file
// Project Name: rv32im_single_cycle
//////////////////////////////////////////////////////////////////////////////////

module reg_file(

    input [4:0] rs1,rs2,rd,
    input [31:0]writeback_data,
    input clk,rst,reg_write,
    output [31:0] read_data1,read_data2
    );
    
    integer i;
    reg [31:0] register[0:31];
    
    assign read_data1 = register[rs1];
    assign read_data2 = register[rs2];
    
    always @(posedge clk)
    begin
        if(rst) begin
            for(i=0;i<32;i=i+1) begin
                register[i] <= 32'h0;
                end
            end
        else begin
            if(reg_write == 1'b1 && rd!=0)
                register[rd] <= writeback_data;
            end
    end
endmodule
