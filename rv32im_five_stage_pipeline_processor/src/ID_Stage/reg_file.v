`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: reg_file
// Project Name: rv32im_single_cycle
//////////////////////////////////////////////////////////////////////////////////

module reg_file(
    input        clk,
    input        rst,
    
    input        reg_write,
    input [4:0]  rs1,
    input [4:0]  rs2,
    input [4:0]  rd,
    input [31:0] writeback_data,
        
    output [31:0] read_data1,
    output [31:0] read_data2
    );
    
    integer i;
    reg [31:0] register[0:31];
    
    assign read_data1 = (reg_write && rd != 0 && rd == rs1) ? writeback_data : register[rs1];

    assign read_data2 = (reg_write && rd != 0 && rd == rs2) ? writeback_data : register[rs2];
    
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
