`timescale 1ns / 1ps

module matrix_mul_tb;

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
                "T=%0t PC=%h INST=%h STALL=%b FLUSH=%b X10=%h X12=%h X13=%h X14=%h X15=%h",
                $time,
                dut.datapath_inst.pc,
                dut.datapath_inst.instruction_id,
                dut.datapath_inst.stall,
                dut.datapath_inst.flush,
                dut.datapath_inst.reg_file_inst.register[10],
                dut.datapath_inst.reg_file_inst.register[12],
                dut.datapath_inst.reg_file_inst.register[13],
                dut.datapath_inst.reg_file_inst.register[14],
                dut.datapath_inst.reg_file_inst.register[15]
            );

        end

    end

    initial begin

        logfile = $fopen(
            "matrix_mul_output.txt",
            "w"
        );

        if (logfile == 0) begin
            $display("ERROR: Could not open output file!");
            $finish;
        end

        $display("Output log opened successfully.");


        $readmemh(
            "matrix_mul_original.mem",
            dut.datapath_inst.instr_mem_inst.memory
        );


        dut.datapath_inst.data_mem_inst.memory[95]  = 32'd1;
        dut.datapath_inst.data_mem_inst.memory[96]  = 32'd2;
        dut.datapath_inst.data_mem_inst.memory[97]  = 32'd3;
        dut.datapath_inst.data_mem_inst.memory[98]  = 32'd4;

        dut.datapath_inst.data_mem_inst.memory[99]  = 32'd5;
        dut.datapath_inst.data_mem_inst.memory[100] = 32'd6;
        dut.datapath_inst.data_mem_inst.memory[101] = 32'd7;
        dut.datapath_inst.data_mem_inst.memory[102] = 32'd8;


        clk = 1'b0;
        rst = 1'b1;

        #20;
        rst = 1'b0;

        wait (
            dut.datapath_inst.reg_file_inst.register[10]
            == 32'h00000013
        );

        #50;

        $fdisplay(logfile, "");
        $fdisplay(logfile, "==============================================");
        $fdisplay(logfile, "          MATRIX MULTIPLICATION");
        $fdisplay(logfile, "==============================================");

        $fdisplay(logfile,
            "x10 (a0) = %h",
            dut.datapath_inst.reg_file_inst.register[10]
        );

        $fdisplay(logfile,
            "Expected = 00000013"
        );

        $fdisplay(logfile, "==============================================");


        if (
            dut.datapath_inst.reg_file_inst.register[10]
            == 32'h00000013
        )
        begin

            $fdisplay(logfile,
                "          MATRIX MULTIPLICATION TEST PASSED"
            );

            $display("");
            $display("==============================================");
            $display(" MATRIX MULTIPLICATION TEST PASSED");
            $display(" x10 = %h",
                dut.datapath_inst.reg_file_inst.register[10]
            );
            $display("==============================================");

        end
        else
        begin

            $fdisplay(logfile,
                "          MATRIX MULTIPLICATION TEST FAILED"
            );

            $display("");
            $display("==============================================");
            $display(" MATRIX MULTIPLICATION TEST FAILED");
            $display(" x10 = %h",
                dut.datapath_inst.reg_file_inst.register[10]
            );
            $display("==============================================");

        end


        $fdisplay(logfile, "");
        $fdisplay(logfile, "DATA MEMORY");

        $fdisplay(logfile, "0x17c = %h",
            dut.datapath_inst.data_mem_inst.memory[95]);

        $fdisplay(logfile, "0x180 = %h",
            dut.datapath_inst.data_mem_inst.memory[96]);

        $fdisplay(logfile, "0x184 = %h",
            dut.datapath_inst.data_mem_inst.memory[97]);

        $fdisplay(logfile, "0x188 = %h",
            dut.datapath_inst.data_mem_inst.memory[98]);

        $fdisplay(logfile, "0x18c = %h",
            dut.datapath_inst.data_mem_inst.memory[99]);

        $fdisplay(logfile, "0x190 = %h",
            dut.datapath_inst.data_mem_inst.memory[100]);

        $fdisplay(logfile, "0x194 = %h",
            dut.datapath_inst.data_mem_inst.memory[101]);

        $fdisplay(logfile, "0x198 = %h",
            dut.datapath_inst.data_mem_inst.memory[102]);

        $fdisplay(logfile, "==============================================");


        $fclose(logfile);

        $display("");
        $display("Log saved to:");
        $display("matrix_mul_output.txt");

        $finish;

    end

endmodule
