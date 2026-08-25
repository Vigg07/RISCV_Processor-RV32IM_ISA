`timescale 1ns / 1ps

module rv32im_processor_tb;

    reg clk;
    reg rst;

    rv32im_processor dut(
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin

        $readmemh("instr.mem",
                  dut.datapath_inst.instr_mem_inst.memory);

        clk = 0;
        rst = 1;

        // Reset
        #20;
        rst = 0;

        #500;

        $display("========================================");
        $display("       RV32IM PROCESSOR TEST");
        $display("========================================");

        $display("x1  = %0d", dut.datapath_inst.reg_file_inst.register[1]);
        $display("x2  = %0d", dut.datapath_inst.reg_file_inst.register[2]);
        $display("x3  = %0d", dut.datapath_inst.reg_file_inst.register[3]);
        $display("x4  = %0d", dut.datapath_inst.reg_file_inst.register[4]);
        $display("x5  = %0d", dut.datapath_inst.reg_file_inst.register[5]);
        $display("x6  = %0d", dut.datapath_inst.reg_file_inst.register[6]);
        $display("x7  = %0d", dut.datapath_inst.reg_file_inst.register[7]);
        $display("x8  = %0d", dut.datapath_inst.reg_file_inst.register[8]);
        $display("x9  = %0d", dut.datapath_inst.reg_file_inst.register[9]);
        $display("x10 = %0d", dut.datapath_inst.reg_file_inst.register[10]);
        $display("x11 = %0d", dut.datapath_inst.reg_file_inst.register[11]);
        $display("x12 = %0d", dut.datapath_inst.reg_file_inst.register[12]);
        $display("x13 = %0d", dut.datapath_inst.reg_file_inst.register[13]);
        $display("x14 = %0d", dut.datapath_inst.reg_file_inst.register[14]);
        $display("x15 = %0d", dut.datapath_inst.reg_file_inst.register[15]);
        $display("x16 = %0d", dut.datapath_inst.reg_file_inst.register[16]);
        $display("x17 = %0d", dut.datapath_inst.reg_file_inst.register[17]);
        $display("x18 = %0d", dut.datapath_inst.reg_file_inst.register[18]);
        $display("x19 = %0d", dut.datapath_inst.reg_file_inst.register[19]);
        $display("x20 = %0d", dut.datapath_inst.reg_file_inst.register[20]);
        $display("x21 = %0d", dut.datapath_inst.reg_file_inst.register[21]);
        $display("x22 = %0d", dut.datapath_inst.reg_file_inst.register[22]);
        $display("x23 = %0d", dut.datapath_inst.reg_file_inst.register[23]);
        $display("x24 = %0d", dut.datapath_inst.reg_file_inst.register[24]);
        $display("x27 = %0h", dut.datapath_inst.reg_file_inst.register[27]);
        $display("x28 = %0h", dut.datapath_inst.reg_file_inst.register[28]);
        $display("x26 = %0h", dut.datapath_inst.reg_file_inst.register[26]);
        $display("x30 = %0d", dut.datapath_inst.reg_file_inst.register[30]);

        $display("Memory[0] = %0d",
                 dut.datapath_inst.data_mem_inst.memory[0]);

        $display("========================================");

        // Basic checks

        if (dut.datapath_inst.reg_file_inst.register[1]  == 10 &&
            dut.datapath_inst.reg_file_inst.register[2]  == 5  &&
            dut.datapath_inst.reg_file_inst.register[3]  == 17 &&
            dut.datapath_inst.reg_file_inst.register[4]  == 18 &&
            dut.datapath_inst.reg_file_inst.register[5]  == 36 &&
            dut.datapath_inst.reg_file_inst.register[6]  == 15 &&
            dut.datapath_inst.reg_file_inst.register[7]  == 5  &&
            dut.datapath_inst.reg_file_inst.register[8]  == 0  &&
            dut.datapath_inst.reg_file_inst.register[9]  == 15 &&
            dut.datapath_inst.reg_file_inst.register[10] == 15 &&
            dut.datapath_inst.reg_file_inst.register[11] == 1  &&
            dut.datapath_inst.reg_file_inst.register[12] == 1  &&
            dut.datapath_inst.reg_file_inst.register[13] == 50 &&
            dut.datapath_inst.reg_file_inst.register[14] == 2  &&
            dut.datapath_inst.reg_file_inst.register[15] == 0  &&
            dut.datapath_inst.reg_file_inst.register[16] == 50 &&
            dut.datapath_inst.reg_file_inst.register[17] == 123 &&
            dut.datapath_inst.reg_file_inst.register[18] == 45 &&
            dut.datapath_inst.reg_file_inst.register[19] == 1  &&
            dut.datapath_inst.reg_file_inst.register[20] == 2  &&
            dut.datapath_inst.reg_file_inst.register[21] == 3  &&
            dut.datapath_inst.reg_file_inst.register[22] == 4  &&
            dut.datapath_inst.reg_file_inst.register[24] == 55 &&
            dut.datapath_inst.reg_file_inst.register[27] == 32'h12345000 &&
            dut.datapath_inst.reg_file_inst.register[28] == 32'h0000009c &&
            dut.datapath_inst.reg_file_inst.register[30] == 77 &&
            dut.datapath_inst.data_mem_inst.memory[0] == 50)
        begin
            $display("        ALL TESTS PASSED");
        end
        else begin
            $display("        TEST FAILED");
        end

        $display("========================================");

        $finish;

    end

endmodule