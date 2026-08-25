`timescale 1ns / 1ps

module tb_data_mem;

    reg clk;
    reg mem_read,mem_write;
    reg [31:0] write_data;
    reg [31:0] address;
    
    wire [31:0] read_data;
    
    data_mem dut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
        );
        
    always #5 clk = ~clk;
    
    initial begin
    
        clk = 0;
        mem_read = 0;
        mem_write = 0;
        address = 0;
        write_data = 0;
        
        address = 32'h00000010;
        write_data = 32'h12345678;
        mem_write = 1;
        
        #10;
        
        mem_write = 0;
        $display("SW @ 0x10 = %h (Expected: 12345678)", dut.memory[address[31:2]]); 
        
        mem_read = 1; 
        #1; 
        $display("LW @ 0x10 = %h (Expected: 12345678)", read_data); 
        mem_read = 0;
        
        address = 32'h00000020; 
        write_data = 32'hDEADBEEF; 
        mem_write = 1; 
        #10; 
        mem_write = 0; 
        mem_read = 1; 
        #1; 
        $display("LW @ 0x20 = %h (Expected: DEADBEEF)", read_data); 
        mem_read = 0; 
        
        address = 32'h00000010; 
        mem_read = 1; 
        #1; 
        $display("LW @ 0x10 = %h (Expected: 12345678)", read_data); 
        mem_read = 0; 
        $finish; 
    end 
        
endmodule
