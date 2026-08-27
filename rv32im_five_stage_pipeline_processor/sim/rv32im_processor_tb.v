`timescale 1ns / 1ps

module rv32im_processor_tb;

    reg clk;
    reg rst;

    rv32im_processor dut(
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Load test instructions
        $readmemh(
            "instr.mem",
            dut.datapath_inst.instr_mem_inst.memory
        );

        // Initial conditions
        clk = 0;
        rst = 1;

        // Reset
        #20;
        rst = 0;

        // Pipeline monitor
        $monitor(
            "Time=%0t | PC=%h | STALL=%b | FLUSH=%b | F_A=%b | F_B=%b | x0=%0d | x1=%0d | x2=%0d | x3=%0d | x4=%0d | x5=%0d | x6=%0d | x7=%0d | x8=%0d",
            $time,
            dut.datapath_inst.pc,
            dut.datapath_inst.stall,
            dut.datapath_inst.flush,
            dut.datapath_inst.forward_a,
            dut.datapath_inst.forward_b,
            dut.datapath_inst.reg_file_inst.register[0],
            dut.datapath_inst.reg_file_inst.register[1],
            dut.datapath_inst.reg_file_inst.register[2],
            dut.datapath_inst.reg_file_inst.register[3],
            dut.datapath_inst.reg_file_inst.register[4],
            dut.datapath_inst.reg_file_inst.register[5],
            dut.datapath_inst.reg_file_inst.register[6],
            dut.datapath_inst.reg_file_inst.register[7],
            dut.datapath_inst.reg_file_inst.register[8]
        );

        // Allow pipeline to complete
        #300;

        // Final results
        $display("========================================");
        $display("       CORNER CASE VERIFICATION");
        $display("========================================");

        $display("x0 = %0d",
            dut.datapath_inst.reg_file_inst.register[0]);

        $display("x1 = %0d",
            dut.datapath_inst.reg_file_inst.register[1]);

        $display("x2 = %0d",
            dut.datapath_inst.reg_file_inst.register[2]);

        $display("x3 = %0d",
            dut.datapath_inst.reg_file_inst.register[3]);

        $display("x4 = %0d",
            dut.datapath_inst.reg_file_inst.register[4]);

        $display("x5 = %0d",
            dut.datapath_inst.reg_file_inst.register[5]);

        $display("x6 = %0d",
            dut.datapath_inst.reg_file_inst.register[6]);

        $display("x7 = %0d",
            dut.datapath_inst.reg_file_inst.register[7]);

        $display("x8 = %0d",
            dut.datapath_inst.reg_file_inst.register[8]);

        $display("Memory[0] = %0d",
            dut.datapath_inst.data_mem_inst.memory[0]);

        $display("========================================");

        // Verification
        if (
            dut.datapath_inst.reg_file_inst.register[0] == 0 &&
            dut.datapath_inst.reg_file_inst.register[1] == 5 &&
            dut.datapath_inst.reg_file_inst.register[2] == 32'hFFFFFFFF &&
            dut.datapath_inst.reg_file_inst.register[3] == 4 &&
            dut.datapath_inst.reg_file_inst.register[4] == 9 &&
            dut.datapath_inst.reg_file_inst.register[5] == 8 &&
            dut.datapath_inst.reg_file_inst.register[6] == 16 &&
            dut.datapath_inst.reg_file_inst.register[7] == 32 &&
            dut.datapath_inst.reg_file_inst.register[8] == 0 &&
            dut.datapath_inst.data_mem_inst.memory[0] == 16
        )
        begin
            $display("       TEST PASSED");
        end
        else
        begin
          $display("        TEST FAILED");
        end

        $display("========================================");

        $finish;

    end

endmodule
