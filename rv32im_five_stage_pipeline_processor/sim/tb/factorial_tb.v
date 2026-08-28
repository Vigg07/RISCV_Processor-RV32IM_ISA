`timescale 1ns / 1ps

module factorial_tb;

    reg clk;
    reg rst;

    rv32im_processor dut(
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Initialize
        clk = 0;
        rst = 1;

        // Load factorial instructions
        $readmemh(
            "factorial.mem",
            dut.datapath_inst.instr_mem_inst.memory
        );

        // Reset
        #20;
        rst = 0;

        // Allow processor to execute
        #5000;

        $display("");
        $display("==============================================");
        $display("             FACTORIAL BENCHMARK");
        $display("==============================================");

        $display("x10 (a0) = %h",
            dut.datapath_inst.reg_file_inst.register[10]);

        $display("Expected = 00000078");

        $display("==============================================");

        if (dut.datapath_inst.reg_file_inst.register[10] == 32'h00000078)
        begin
            $display("             FACTORIAL TEST PASSED");
        end
        else
        begin
            $display("             FACTORIAL TEST FAILED");
        end

        $display("==============================================");

        $finish;

    end

endmodule