`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: datapath
// Project Name: rv32im_single_cycle 
//////////////////////////////////////////////////////////////////////////////////

module datapath(
    input clk,
    input rst
    );
    
    // PC
    wire [31:0] pc;
    wire [31:0] next_pc;
    
    // Instruction
    wire [31:0] instruction;
    
    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [4:0]  rs1,rs2;
    wire [4:0]  rd;
    
    // Main Decoder
    wire reg_write;
    wire alu_src;
    wire mem_write;
    wire mem_read;
    wire branch;
    wire jump;
    wire is_mul_div;
    
    wire [1:0] alu_op;
    wire [2:0] wb_sel;
    
    // Register File
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    
    // Immediate Generator
    wire [31:0] imm_out;
    
    // ALU
    wire [3:0]  alu_ctrl;
    wire [31:0] alu_b;
    wire [31:0] alu_result;
    
    // MUL/DIV
    wire [31:0] mul_div_result;
    
    // Data Memory
    wire [31:0] mem_data;
    
    // Branch
    wire branch_taken;
    
    // PC target Generator
    wire [31:0] pc_plus4;
    wire [31:0] branch_target;
    wire [31:0] jal_target;
    wire [31:0] jalr_target;
    wire [31:0] auipc_data;
    
    // PC Control
    wire [1:0] pc_sel;
    
    // Writeback
    wire [31:0] writeback_data;
    
    // Instruction Field Extraction
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];
    
    
    pc pc_inst(
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .pc(pc)
        );
    
    instr_mem instr_mem_inst(
        .addr(pc),
        .instruction(instruction)
        );
    
    main_decoder main_decoder_inst(
        .opcode(opcode),
        .funct7(funct7),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op),
        .wb_sel(wb_sel),
        .is_mul_div(is_mul_div)
        );
        
    reg_file reg_file_inst(
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .writeback_data(writeback_data),
        .clk(clk),
        .rst(rst),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
        );
    
    imm_gen imm_gen_inst(
        .instruction(instruction),
        .imm_out(imm_out)
        );
        
    alu_decoder alu_decoder_inst(
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .opcode(opcode),
        .alu_ctrl(alu_ctrl)
        );
   
   alu_mux alu_mux_inst(
        .read_data2(read_data2),
        .imm(imm_out),
        .alu_src(alu_src),
        .alu_b(alu_b)
        );
    
    alu alu_inst(
        .a(read_data1),
        .b(alu_b),
        .alu_ctrl(alu_ctrl),
        .result(alu_result)
        );   
    
    mul_div_unit mul_div_unit_inst(
        .a(read_data1),
        .b(read_data2),
        .funct3(funct3),
        .result(mul_div_result)
        );        
        
    data_mem data_mem_inst(
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(alu_result),
        .write_data(read_data2),
        .read_data(mem_data)
        );
        
    branch_control branch_control_inst(
        .branch(branch),
        .funct3(funct3),
        .a(read_data1),
        .b(read_data2),
        .branch_taken(branch_taken) 
        );
        
    pc_target_gen pc_target_gen_inst(
        .pc(pc),
        .imm_out(imm_out),
        .rs1_data(read_data1),
        .branch_target(branch_target),
        .jal_target(jal_target),
        .jalr_target(jalr_target),
        .auipc_data(auipc_data),
        .pc_plus4(pc_plus4)
        );
        
    pc_control pc_control_inst(
        .jump(jump),
        .branch_taken(branch_taken),
        .opcode(opcode),
        .pc_sel(pc_sel)
        );
        
    pc_mux pc_mux_inst(
       .pc_sel(pc_sel),
       .pc_plus4(pc_plus4),
       .branch_target(branch_target),
       .jal_target(jal_target),
       .jalr_target(jalr_target),
       .next_pc(next_pc)
       );
    
    writeback_mux writeback_mux_inst(
        .wb_sel(wb_sel),
        .is_mul_div(is_mul_div),
        .mul_div_result(mul_div_result),
        .alu_result(alu_result),
        .imm_out(imm_out),
        .mem_data(mem_data),
        .auipc_data(auipc_data),
        .pc_plus4(pc_plus4),
        .writeback_data(writeback_data)
        );     
    
endmodule
