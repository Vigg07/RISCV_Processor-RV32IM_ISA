`timescale 1ns / 1ps

module fibonacci_tb;

    reg clk;
    reg rst;

    rv32im_processor dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;

        // Load Fibonacci program
        $readmemh(
            "fibonacci.mem",
            dut.datapath_inst.instr_mem_inst.memory
        );

        // Reset
        #20;
        rst = 0;

        // Run program
        #5000;

        $display("");
        $display("==============================================");
        $display("             FIBONACCI BENCHMARK");
        $display("==============================================");

        $display("x10 (a0) = %h",
            dut.datapath_inst.reg_file_inst.register[10]);

        $display("Expected = 00000037");

        $display("==============================================");

        if (dut.datapath_inst.reg_file_inst.register[10] == 32'h00000037)
        begin
            $display("             FIBONACCI TEST PASSED");
        end
        else
        begin
            $display("             FIBONACCI TEST FAILED");
        end

        $display("==============================================");

        $finish;

    end

endmodule