`timescale 1ns / 1ps

module corner_case_tb;

    reg clk;
    reg rst;

    rv32im_processor dut(
        .clk(clk),
        .rst(rst)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin

        // Load corner-case program
        $readmemh("corner_case.mem",
                  dut.datapath_inst.instr_mem_inst.memory);

        clk = 0;
        rst = 1;

        // Reset
        #20;
        rst = 0;

        #500;

        $display("========================================");
        $display("       RV32IM CORNER CASE TEST");
        $display("========================================");

        $display("x0  = %h", dut.datapath_inst.reg_file_inst.register[0]);
        $display("x1  = %h", dut.datapath_inst.reg_file_inst.register[1]);
        $display("x2  = %h", dut.datapath_inst.reg_file_inst.register[2]);
        $display("x3  = %h", dut.datapath_inst.reg_file_inst.register[3]);
        $display("x4  = %h", dut.datapath_inst.reg_file_inst.register[4]);
        $display("x5  = %h", dut.datapath_inst.reg_file_inst.register[5]);
        $display("x6  = %h", dut.datapath_inst.reg_file_inst.register[6]);
        $display("x7  = %h", dut.datapath_inst.reg_file_inst.register[7]);
        $display("x8  = %h", dut.datapath_inst.reg_file_inst.register[8]);
        $display("x9  = %h", dut.datapath_inst.reg_file_inst.register[9]);

        $display("x10 = %h", dut.datapath_inst.reg_file_inst.register[10]);
        $display("x11 = %h", dut.datapath_inst.reg_file_inst.register[11]);
        $display("x12 = %h", dut.datapath_inst.reg_file_inst.register[12]);
        $display("x13 = %h", dut.datapath_inst.reg_file_inst.register[13]);
        $display("x14 = %h", dut.datapath_inst.reg_file_inst.register[14]);
        $display("x15 = %h", dut.datapath_inst.reg_file_inst.register[15]);
        $display("x16 = %h", dut.datapath_inst.reg_file_inst.register[16]);
        $display("x17 = %h", dut.datapath_inst.reg_file_inst.register[17]);
        $display("x18 = %h", dut.datapath_inst.reg_file_inst.register[18]);
        $display("x19 = %h", dut.datapath_inst.reg_file_inst.register[19]);
        $display("x20 = %h", dut.datapath_inst.reg_file_inst.register[20]);
        $display("x21 = %h", dut.datapath_inst.reg_file_inst.register[21]);
        $display("x22 = %h", dut.datapath_inst.reg_file_inst.register[22]);
        $display("x23 = %h", dut.datapath_inst.reg_file_inst.register[23]);
        $display("x24 = %h", dut.datapath_inst.reg_file_inst.register[24]);
        $display("x25 = %h", dut.datapath_inst.reg_file_inst.register[25]);
        $display("x26 = %h", dut.datapath_inst.reg_file_inst.register[26]);
        $display("x27 = %h", dut.datapath_inst.reg_file_inst.register[27]);
        $display("x28 = %h", dut.datapath_inst.reg_file_inst.register[28]);
        $display("x29 = %h", dut.datapath_inst.reg_file_inst.register[29]);
        $display("x30 = %h", dut.datapath_inst.reg_file_inst.register[30]);
        $display("x31 = %h", dut.datapath_inst.reg_file_inst.register[31]);

        $display("Memory[0] = %h",
                 dut.datapath_inst.data_mem_inst.memory[0]);

        $display("========================================");

        if (
            // Basic values
            dut.datapath_inst.reg_file_inst.register[0]  == 32'h00000000 &&
            dut.datapath_inst.reg_file_inst.register[1]  == 32'hFFFFFFFF &&
            dut.datapath_inst.reg_file_inst.register[2]  == 32'h00000001 &&
            dut.datapath_inst.reg_file_inst.register[3]  == 32'h80000000 &&
            dut.datapath_inst.reg_file_inst.register[4]  == 32'h00000009 &&
            dut.datapath_inst.reg_file_inst.register[5]  == 32'h0000001F &&

            // Shift and comparison corner cases
            dut.datapath_inst.reg_file_inst.register[6]  == 32'h40000000 &&
            dut.datapath_inst.reg_file_inst.register[7]  == 32'hC0000000 &&
            dut.datapath_inst.reg_file_inst.register[8]  == 32'h00000001 &&
            dut.datapath_inst.reg_file_inst.register[9]  == 32'h00000000 &&

            // M extension
            dut.datapath_inst.reg_file_inst.register[10] == 32'hFFFFFFFF &&
            dut.datapath_inst.reg_file_inst.register[11] == 32'hFFFFFFFF &&
            dut.datapath_inst.reg_file_inst.register[12] == 32'hFFFFFFFF &&
            dut.datapath_inst.reg_file_inst.register[13] == 32'h00000000 &&
            dut.datapath_inst.reg_file_inst.register[14] == 32'hFFFFFFFF &&
            dut.datapath_inst.reg_file_inst.register[15] == 32'hFFFFFFFF &&
            dut.datapath_inst.reg_file_inst.register[16] == 32'h00000000 &&
            dut.datapath_inst.reg_file_inst.register[17] == 32'h00000000 &&

            // Division corner cases
            dut.datapath_inst.reg_file_inst.register[18] == 32'hFFFFFFFF &&
            dut.datapath_inst.reg_file_inst.register[19] == 32'hFFFFFFFF &&
            dut.datapath_inst.reg_file_inst.register[20] == 32'hFFFFFFFF &&
            dut.datapath_inst.reg_file_inst.register[21] == 32'hFFFFFFFF &&
            dut.datapath_inst.reg_file_inst.register[22] == 32'h80000000 &&
            dut.datapath_inst.reg_file_inst.register[23] == 32'h00000000 &&

            // Memory, LUI, AUIPC
            dut.datapath_inst.reg_file_inst.register[24] == 32'hFFFFFFFF &&
            dut.datapath_inst.reg_file_inst.register[25] == 32'h12345000 &&
            dut.datapath_inst.reg_file_inst.register[26] == 32'h00001068 &&

            // Branches
            dut.datapath_inst.reg_file_inst.register[27] == 32'h00000009 &&
            dut.datapath_inst.reg_file_inst.register[28] == 32'h00000009 &&
            dut.datapath_inst.reg_file_inst.register[29] == 32'h00000009 &&
            dut.datapath_inst.reg_file_inst.register[30] == 32'h00000009 &&
            dut.datapath_inst.reg_file_inst.register[31] == 32'h00000007 &&

            // Memory
            dut.datapath_inst.data_mem_inst.memory[0] == 32'hFFFFFFFF
        )
        begin
            $display("       ALL CORNER CASES PASSED");
        end
        else
        begin
            $display("       CORNER CASE TEST FAILED");
        end

        $display("========================================");

        $finish;

    end

endmodule