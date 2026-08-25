module r_type_tb;

    reg clk;
    reg rst;
    
    rv32im_processor dut(
        .clk(clk),
        .rst(rst)
    );
        
    always #5 clk = ~clk;
        
    initial begin

        $readmemh("r_type.mem",
                  dut.datapath_inst.instr_mem_inst.memory);
            
        clk = 0;
        rst = 1;
            
        #20;
        rst = 0;
            
        #160;
            
        $finish;
            
    end

endmodule
