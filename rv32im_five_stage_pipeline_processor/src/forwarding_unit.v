`timescale 1ns / 1ps

module forwarding_unit(

    input [4:0] rs1_ex,
    input [4:0] rs2_ex,

    input [4:0] rd_mem,
    input       reg_write_mem,
    input       mem_read_mem,

    input [4:0] rd_wb,
    input       reg_write_wb,

    output reg [1:0] forward_a,
    output reg [1:0] forward_b

);

    always @(*) begin

        // Forwarding for ALU input A
        if ((rs1_ex != 5'b0) && (rs1_ex == rd_mem) && (reg_write_mem == 1'b1) && (mem_read_mem == 1'b0))
            forward_a = 2'b01;
        else if ((rs1_ex != 5'b0) && (rs1_ex == rd_wb) && (reg_write_wb == 1'b1))
            forward_a = 2'b10;
        else
            forward_a = 2'b00;

        // Forwarding for ALU input B
        if ((rs2_ex != 5'b0) && (rs2_ex == rd_mem) && (reg_write_mem == 1'b1) && (mem_read_mem == 1'b0))
            forward_b = 2'b01;
        else if ((rs2_ex != 5'b0) && (rs2_ex == rd_wb) && (reg_write_wb == 1'b1))
            forward_b = 2'b10;
        else
            forward_b = 2'b00;
    end

endmodule
