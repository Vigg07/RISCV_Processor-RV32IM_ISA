`timescale 1ns / 1ps

module bubble_sort_tb;

    reg clk;
    reg rst;

    integer logfile;

    rv32im_processor dut(
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

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

    initial begin

        logfile = $fopen(
            "bubble_sort_output.txt",
            "w"
        );

        if (logfile == 0) begin
            $display("ERROR: Could not open output file!");
            $finish;
        end

        $display("Output log opened successfully.");

        $readmemh(
            "bubble_sort_32bit.mem",
            dut.datapath_inst.instr_mem_inst.memory
        );
        dut.datapath_inst.data_mem_inst.memory[75] = 32'd5;
        dut.datapath_inst.data_mem_inst.memory[76] = 32'd2;
        dut.datapath_inst.data_mem_inst.memory[77] = 32'd4;
        dut.datapath_inst.data_mem_inst.memory[78] = 32'd1;
        dut.datapath_inst.data_mem_inst.memory[79] = 32'd3;


        clk = 0;
        rst = 1;

        #20;
        rst = 0;

        dut.datapath_inst.reg_file_inst.register[2] = 32'h00000100;

        #20000;

        $fdisplay(logfile, "");
        $fdisplay(logfile, "==============================================");
        $fdisplay(logfile, "             BUBBLE SORT TEST");
        $fdisplay(logfile, "==============================================");

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

        $fdisplay(logfile, "");
        $fdisplay(logfile, "x10 (a0) = %h",
            dut.datapath_inst.reg_file_inst.register[10]);

        $fdisplay(logfile, "Expected x10 = 00000001");

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

        $fclose(logfile);

        $display("");
        $display("==============================================");
        $display("Simulation finished.");
        $display("Log saved to:");
        $display("bubble_sort_output.txt");
        $display("==============================================");

        $finish;

    end

endmodule
