`timescale 1ns / 1ps

module bubble_sort_tb;

    reg clk;
    reg rst;

    integer logfile;

    rv32im_processor dut(
        .clk(clk),
        .rst(rst)
    );

    // ============================================================
    // CLOCK
    // ============================================================

    always #5 clk = ~clk;


    // ============================================================
    // LOGGING
    // ============================================================

    always @(posedge clk) begin

        if (!rst) begin

            $fdisplay(logfile,
                "T=%0t PC=%h INST=%h STALL=%b FLUSH=%b X10=%h X2=%h",
                $time,
                dut.datapath_inst.pc,
                dut.datapath_inst.instruction_id,
                dut.datapath_inst.stall,
                dut.datapath_inst.flush,
                dut.datapath_inst.reg_file_inst.register[10],
                dut.datapath_inst.reg_file_inst.register[2]
            );

        end

    end


    // ============================================================
    // TEST
    // ============================================================

    initial begin

        // --------------------------------------------------------
        // OPEN LOG FILE
        // --------------------------------------------------------

        logfile = $fopen(
            "/home/vigg/Vigg/Projects/FYP/FYP_Design/rv32im_5stage_pipeline/Benchmarks/bubble_sort_output.txt",
            "w"
        );

        if (logfile == 0) begin
            $display("ERROR: Could not open output file!");
            $finish;
        end

        $display("Output log opened successfully.");


        // --------------------------------------------------------
        // LOAD PROGRAM
        // --------------------------------------------------------

        $readmemh(
            "bubble_sort_32bit.mem",
            dut.datapath_inst.instr_mem_inst.memory
        );


        // --------------------------------------------------------
        // INITIALIZE DATA MEMORY
        //
        // C program:
        //
        // int arr[5] = {5, 2, 4, 1, 3};
        //
        // Initial array is loaded by the program from:
        //
        // 0x12C = 300
        //
        // 300 / 4 = 75
        // --------------------------------------------------------

        dut.datapath_inst.data_mem_inst.memory[75] = 32'd5;
        dut.datapath_inst.data_mem_inst.memory[76] = 32'd2;
        dut.datapath_inst.data_mem_inst.memory[77] = 32'd4;
        dut.datapath_inst.data_mem_inst.memory[78] = 32'd1;
        dut.datapath_inst.data_mem_inst.memory[79] = 32'd3;


        // --------------------------------------------------------
        // INITIAL CONDITIONS
        // --------------------------------------------------------

        clk = 0;
        rst = 1;


        // --------------------------------------------------------
        // RESET
        // --------------------------------------------------------

        #20;
        rst = 0;


        // --------------------------------------------------------
        // INITIALIZE STACK POINTER AFTER RESET
        //
        // The program uses stack memory for the actual array.
        //
        // x2 = 0x100
        // After:
        //
        //     addi sp,sp,-48
        //
        // sp becomes:
        //
        //     0x100 - 48 = 0xD0
        //
        // Therefore the actual array is located at:
        //
        // 0xD0, 0xD4, 0xD8, 0xDC, 0xE0
        // --------------------------------------------------------

        dut.datapath_inst.reg_file_inst.register[2] = 32'h00000100;


        // --------------------------------------------------------
        // RUN
        // --------------------------------------------------------

        #20000;


        // ========================================================
        // FINAL RESULT
        // ========================================================

        $fdisplay(logfile, "");
        $fdisplay(logfile, "==============================================");
        $fdisplay(logfile, "             BUBBLE SORT TEST");
        $fdisplay(logfile, "==============================================");


        // --------------------------------------------------------
        // SORTED ARRAY
        //
        // Actual array location:
        //
        // 0xD0 / 4 = 52
        // --------------------------------------------------------

        $fdisplay(logfile, "ARRAY AFTER SORT:");

        $fdisplay(logfile, "arr[0] = %h",
            dut.datapath_inst.data_mem_inst.memory[52]);

        $fdisplay(logfile, "arr[1] = %h",
            dut.datapath_inst.data_mem_inst.memory[53]);

        $fdisplay(logfile, "arr[2] = %h",
            dut.datapath_inst.data_mem_inst.memory[54]);

        $fdisplay(logfile, "arr[3] = %h",
            dut.datapath_inst.data_mem_inst.memory[55]);

        $fdisplay(logfile, "arr[4] = %h",
            dut.datapath_inst.data_mem_inst.memory[56]);


        // --------------------------------------------------------
        // RETURN VALUE
        // --------------------------------------------------------

        $fdisplay(logfile, "");
        $fdisplay(logfile, "x10 (a0) = %h",
            dut.datapath_inst.reg_file_inst.register[10]);

        $fdisplay(logfile, "Expected x10 = 00000001");


        // ========================================================
        // CHECK
        // ========================================================

        if (
            dut.datapath_inst.data_mem_inst.memory[52] == 32'd1 &&
            dut.datapath_inst.data_mem_inst.memory[53] == 32'd2 &&
            dut.datapath_inst.data_mem_inst.memory[54] == 32'd3 &&
            dut.datapath_inst.data_mem_inst.memory[55] == 32'd4 &&
            dut.datapath_inst.data_mem_inst.memory[56] == 32'd5 &&
            dut.datapath_inst.reg_file_inst.register[10] == 32'd1
        )
        begin
            $fdisplay(logfile,
                "BUBBLE SORT TEST PASSED"
            );
        end
        else
        begin
            $fdisplay(logfile,
                "BUBBLE SORT TEST FAILED"
            );
        end

        $fdisplay(logfile, "==============================================");


        // --------------------------------------------------------
        // CLOSE
        // --------------------------------------------------------

        $fclose(logfile);

        $display("");
        $display("==============================================");
        $display("Simulation finished.");
        $display("Log saved to:");
        $display("/home/vigg/Vigg/Projects/FYP/FYP_Design/rv32im_5stage_pipeline/Benchmarks/bubble_sort_output.txt");
        $display("==============================================");

        $finish;

    end

endmodule