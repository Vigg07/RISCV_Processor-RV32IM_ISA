
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: datapath
// Project Name: rv32im_5stage_pipeline
//////////////////////////////////////////////////////////////////////////////////

module datapath(
    input clk,
    input rst
);

  //////////// IF STAGE//////////////////
    
    // PC
    wire [31:0] pc;
    wire [31:0] next_pc;
    wire        stall;

    // Instruction
    wire [31:0] instruction;

    // PC + 4
    wire [31:0] pc_plus4;

    // IF/ID Pipeline Register
    wire [31:0] pc_id;
    wire [31:0] pc_plus4_id;
    wire [31:0] instruction_id;
    
    // Branch Control
    wire branch_taken_ex;
    wire jump_ex;
    
    wire flush;
    assign flush = branch_taken_ex | jump_ex;


    pc pc_inst(
        .clk(clk),
        .rst(rst),
        .enable(~stall),
        .next_pc(next_pc),
        .pc(pc)
    );

    instr_mem instr_mem_inst(
        .addr(pc),
        .instruction(instruction)
    );

    pc_plus4 pc_plus4_inst(
        .pc(pc),
        .pc_plus4(pc_plus4)
    );

    if_id if_id_inst(
        .clk(clk),
        .rst(rst),

        .stall(stall),
        .flush(flush),
        .pc_in(pc),
        .pc_plus4_in(pc_plus4),
        .instruction_in(instruction),

        .pc_out(pc_id),
        .pc_plus4_out(pc_plus4_id),
        .instruction_out(instruction_id)
    );


///////////////// ID STAGE ////////////////////
    
    // Instruction fields
    wire [6:0] opcode_id;
    wire [2:0] funct3_id;
    wire [6:0] funct7_id;
    wire [4:0] rs1_id;
    wire [4:0] rs2_id;
    wire [4:0] rd_id;

    assign opcode_id = instruction_id[6:0];
    assign rd_id     = instruction_id[11:7];
    assign funct3_id = instruction_id[14:12];
    assign rs1_id    = instruction_id[19:15];
    assign rs2_id    = instruction_id[24:20];
    assign funct7_id = instruction_id[31:25];


    // Main Decoder signals
    wire       reg_write_id;
    wire       alu_src_id;
    wire       mem_write_id;
    wire       mem_read_id;
    wire       branch_id;
    wire       jump_id;
    wire       is_mul_div_id;

    wire [1:0] alu_op_id;
    wire [2:0] wb_sel_id;


    // Register File
    wire [31:0] read_data1_id;
    wire [31:0] read_data2_id;


    // Immediate Generator
    wire [31:0] imm_id;


    // WB -> REGISTER FILE
    wire [4:0]  rd_wb;
    wire        reg_write_wb;
    wire [31:0] writeback_data_wb;

    // ID/EX PIPELINE REGISTER
    wire [31:0] pc_ex;
    wire [31:0] pc_plus4_ex;
    wire [31:0] imm_ex;

    wire [6:0] opcode_ex;
    wire [6:0] funct7_ex;
    wire [2:0] funct3_ex;

    wire       reg_write_ex;
    wire       alu_src_ex;
    wire       mem_read_ex;
    wire       mem_write_ex;
    wire       branch_ex;

    wire [1:0] alu_op_ex;
    wire [2:0] wb_sel_ex;
    wire       is_mul_div_ex;

    wire [31:0] auipc_data_ex;

    wire [4:0] rs1_ex;
    wire [4:0] rs2_ex;
    wire [4:0] rd_ex;

    wire [31:0] read_data1_ex;
    wire [31:0] read_data2_ex;


    main_decoder main_decoder_inst(
        .opcode(opcode_id),
        .funct7(funct7_id),

        .reg_write(reg_write_id),
        .alu_src(alu_src_id),
        .mem_read(mem_read_id),
        .mem_write(mem_write_id),
        .branch(branch_id),
        .jump(jump_id),
        .is_mul_div(is_mul_div_id),
        .alu_op(alu_op_id),
        .wb_sel(wb_sel_id)
    );


    reg_file reg_file_inst(
        .clk(clk),
        .rst(rst),

        .reg_write(reg_write_wb),
        .rs1(rs1_id),
        .rs2(rs2_id),
        .rd(rd_wb),
        .writeback_data(writeback_data_wb),

        .read_data1(read_data1_id),
        .read_data2(read_data2_id)
    );


    imm_gen imm_gen_inst(
        .instruction(instruction_id),
        .imm_out(imm_id)
    );


    id_ex id_ex_inst(
        .clk(clk),
        .rst(rst),
        
        .stall(stall),
        .flush(flush),
        .pc_in(pc_id),
        .pc_plus4_in(pc_plus4_id),
        .imm_id(imm_id),

        .opcode_in(opcode_id),
        .funct7_in(funct7_id),
        .funct3_in(funct3_id),

        .reg_write_in(reg_write_id),
        .alu_src_in(alu_src_id),
        .mem_read_in(mem_read_id),
        .mem_write_in(mem_write_id),
        .branch_in(branch_id),
        .jump_in(jump_id),
        .alu_op_in(alu_op_id),
        .wb_sel_in(wb_sel_id),
        .is_mul_div_in(is_mul_div_id),

        .rs1_in(rs1_id),
        .rs2_in(rs2_id),
        .rd_in(rd_id),

        .read_data1_in(read_data1_id),
        .read_data2_in(read_data2_id),

        .pc_out(pc_ex),
        .pc_plus4_out(pc_plus4_ex),
        .imm_ex(imm_ex),

        .opcode_out(opcode_ex),
        .funct7_out(funct7_ex),
        .funct3_out(funct3_ex),

        .reg_write_out(reg_write_ex),
        .alu_src_out(alu_src_ex),
        .mem_read_out(mem_read_ex),
        .mem_write_out(mem_write_ex),
        .branch_out(branch_ex),
        .jump_out(jump_ex),
        .alu_op_out(alu_op_ex),
        .wb_sel_out(wb_sel_ex),
        .is_mul_div_out(is_mul_div_ex),

        .rs1_out(rs1_ex),
        .rs2_out(rs2_ex),
        .rd_out(rd_ex),

        .read_data1_out(read_data1_ex),
        .read_data2_out(read_data2_ex)
    );


//////////////// EX STAGE ////////////////////////

    // ALU Decoder
    wire [3:0] alu_ctrl_ex;

    // ALU MUX
    wire [31:0] alu_b_ex;

    // ALU
    wire [31:0] alu_result_ex;

    // MUL/DIV Unit
    wire [31:0] mul_div_result_ex;


    // PC Targets
    wire [31:0] branch_target_ex;
    wire [31:0] jal_target_ex;
    wire [31:0] jalr_target_ex;

    // EX/MEM PIPELINE REGISTER
    wire [31:0] alu_result_mem;
    wire [31:0] mul_div_result_mem;
    wire [31:0] read_data2_mem;

    wire [31:0] pc_plus4_mem;
    wire [31:0] auipc_data_mem;
    wire [31:0] imm_mem;

    wire [4:0] rd_mem;

    wire       reg_write_mem;
    wire       mem_read_mem;
    wire       mem_write_mem;
    wire [2:0] wb_sel_mem;
    wire       is_mul_div_mem;
    
    // forwarding unit
    wire [1:0] forward_a;
    wire [1:0] forward_b;
    
    wire [31:0] alu_a_forwarded;
    wire [31:0] alu_b_forwarded;

  
    alu_decoder alu_decoder_inst(
        .alu_op(alu_op_ex),
        .funct3(funct3_ex),
        .funct7(funct7_ex),
        .opcode(opcode_ex),

        .alu_ctrl(alu_ctrl_ex)
    );


    alu_mux alu_mux_inst(
        .read_data2(alu_b_forwarded),
        .imm(imm_ex),
        .alu_src(alu_src_ex),

        .alu_b(alu_b_ex)
    );


    alu alu_inst(
        .a(alu_a_forwarded),
        .b(alu_b_ex),
        .alu_ctrl(alu_ctrl_ex),

        .result(alu_result_ex)
    );


    mul_div_unit mul_div_unit_inst(
        .a(alu_a_forwarded),
        .b(alu_b_forwarded),
        .funct3(funct3_ex),

        .result(mul_div_result_ex)
    );


    branch_control branch_control_inst(
        .branch(branch_ex),
        .funct3(funct3_ex),
        .a(alu_a_forwarded),
        .b(alu_b_forwarded),

        .branch_taken(branch_taken_ex)
    );


    pc_target_gen pc_target_gen_inst(
        .pc(pc_ex),
        .imm_out(imm_ex),
        .rs1_data(alu_a_forwarded),

        .branch_target(branch_target_ex),
        .jal_target(jal_target_ex),
        .jalr_target(jalr_target_ex),

        .auipc_data(auipc_data_ex),
        .pc_plus4(pc_plus4_ex)
    );  


    ex_mem ex_mem_inst(
        .clk(clk),
        .rst(rst),

        .alu_result_in(alu_result_ex),
        .read_data2_in(alu_b_forwarded),
        .mul_div_result_in(mul_div_result_ex),

        .imm_in(imm_ex),
        .auipc_data_in(auipc_data_ex),
        .pc_plus4_in(pc_plus4_ex),
        .is_mul_div_in(is_mul_div_ex),

        .mem_read_in(mem_read_ex),
        .mem_write_in(mem_write_ex),
        .reg_write_in(reg_write_ex),
        .wb_sel_in(wb_sel_ex),
        .rd_in(rd_ex),

        .alu_result_out(alu_result_mem),
        .read_data2_out(read_data2_mem),
        .mul_div_result_out(mul_div_result_mem),

        .imm_out(imm_mem),
        .auipc_data_out(auipc_data_mem),
        .pc_plus4_out(pc_plus4_mem),
        .is_mul_div_out(is_mul_div_mem),

        .mem_read_out(mem_read_mem),
        .mem_write_out(mem_write_mem),
        .reg_write_out(reg_write_mem),
        .wb_sel_out(wb_sel_mem),
        .rd_out(rd_mem)
    );

    
    // PC CONTROL
    wire [1:0] pc_sel;

    pc_control pc_control_inst(
        .jump(jump_ex),
        .branch_taken(branch_taken_ex),
        .opcode(opcode_ex),

        .pc_sel(pc_sel)
    );


    pc_mux pc_mux_inst(
        .pc_sel(pc_sel),

        .pc_plus4(pc_plus4),
        .branch_target(branch_target_ex),
        .jal_target(jal_target_ex),
        .jalr_target(jalr_target_ex),

        .next_pc(next_pc)
    );


////////////// MEM STAGE /////////////////////
    
    // Data Memory
    wire [31:0] read_data_mem;


    data_mem data_mem_inst(
        .clk(clk),

        .mem_read(mem_read_mem),
        .mem_write(mem_write_mem),
        .address(alu_result_mem),
        .write_data(read_data2_mem),

        .read_data(read_data_mem)
    );

    // MEM/WB PIPELINE REGISTER  
    wire [2:0]  wb_sel_wb;
    wire        is_mul_div_wb;

    wire [31:0] alu_result_wb;
    wire [31:0] mul_div_result_wb;
    wire [31:0] imm_wb;
    wire [31:0] mem_data_wb;
    wire [31:0] auipc_data_wb;
    wire [31:0] pc_plus4_wb;


    mem_wb mem_wb_inst(
        .clk(clk),
        .rst(rst),

        .wb_sel_in(wb_sel_mem),
        .is_mul_div_in(is_mul_div_mem),

        .alu_result_in(alu_result_mem),
        .mul_div_result_in(mul_div_result_mem),
        .imm_in(imm_mem),
        .mem_data_in(read_data_mem),
        .auipc_data_in(auipc_data_mem),
        .pc_plus4_in(pc_plus4_mem),

        .rd_in(rd_mem),
        .reg_write_in(reg_write_mem),

        .wb_sel_out(wb_sel_wb),
        .is_mul_div_out(is_mul_div_wb),

        .alu_result_out(alu_result_wb),
        .mul_div_result_out(mul_div_result_wb),
        .imm_out(imm_wb),
        .mem_data_out(mem_data_wb),
        .auipc_data_out(auipc_data_wb),
        .pc_plus4_out(pc_plus4_wb),

        .rd_out(rd_wb),
        .reg_write_out(reg_write_wb)
    );

///////////////// WB STAGE /////////////////////

    writeback_mux writeback_mux_inst(
        .wb_sel(wb_sel_wb),
        .is_mul_div(is_mul_div_wb),

        .mul_div_result(mul_div_result_wb),
        .alu_result(alu_result_wb),
        .imm_out(imm_wb),
        .mem_data(mem_data_wb),
        .auipc_data(auipc_data_wb),
        .pc_plus4(pc_plus4_wb),

        .writeback_data(writeback_data_wb)
    );
    
    
////////////////// Forwarding unit ///////////////

    forwarding_unit forwarding_unit_inst(
        .rs1_ex(rs1_ex),
        .rs2_ex(rs2_ex),
        .rd_mem(rd_mem),
        .reg_write_mem(reg_write_mem),
        .rd_wb(rd_wb),
        .reg_write_wb(reg_write_wb),
        .forward_a(forward_a),
        .forward_b(forward_b)
        );
    
    forwarding_mux forwarding_mux_a(
        .reg_data(read_data1_ex),
        .alu_result_mem(alu_result_mem),
        .mul_div_result_mem(mul_div_result_mem),
        .writeback_data_wb(writeback_data_wb),
        .is_mul_div_mem(is_mul_div_mem),
        .forward(forward_a),
        .alu_input(alu_a_forwarded)
);
    
    forwarding_mux forwarding_mux_b(
        .reg_data(read_data2_ex),
        .alu_result_mem(alu_result_mem),
        .mul_div_result_mem(mul_div_result_mem),
        .writeback_data_wb(writeback_data_wb),
        .is_mul_div_mem(is_mul_div_mem),
        .forward(forward_b),
        .alu_input(alu_b_forwarded)
);
        
////////////////// Load use hazard //////////////////

    load_use_hazard_unit load_use_hazard_unit_inst(
        .mem_read_ex(mem_read_ex),
        .rd_ex(rd_ex),
        .rs1_id(rs1_id),
        .rs2_id(rs2_id),
        .stall(stall)
        );
        
        
        
endmodule

is it okay now??
