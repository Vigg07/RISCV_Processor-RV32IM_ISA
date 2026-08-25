`timescale 1ns / 1ps

module tb_i_type;
    reg clk;
    reg rst;
    
    rv32im_processor dut(.clk(clk), .rst(rst));
    
    always #5 clk = ~clk;
    
    initial begin
        
        $readmemh("i_type.mem",dut.datapath_inst.instr_mem_inst.memory);
        
        clk = 0;
        rst = 1;
        
        #20;
        rst = 0;
        
        #60;
        $finish;
    end
    
endmodule