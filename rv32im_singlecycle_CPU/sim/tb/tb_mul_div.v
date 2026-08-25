`timescale 1ns / 1ps

module tb_mul_div;
    
    reg [31:0] a,b;
    reg [2:0] funct3;
    wire [31:0] result;
    
    mul_div_unit dut(
        .a(a),
        .b(b),
        .funct3(funct3),
        .result(result)
        );
        
    initial begin
        
        // ============================================================
        // BASIC MULTIPLICATION
        // ============================================================
        
        a = 32'd10;
        b = 32'd5;
        funct3 = 3'b000;
        #10;
        $display("MUL       = %h  (Expected: 00000032)", result);
        
        
        // ============================================================
        // MUL CORNER CASES
        // ============================================================
        
        // 0 * anything
        a = 32'd0;
        b = 32'd123;
        funct3 = 3'b000;
        #10;
        $display("MUL 0     = %h  (Expected: 00000000)", result);
        
        // -1 * 5
        a = -32'sd1;
        b = 32'd5;
        funct3 = 3'b000;
        #10;
        $display("MUL -1*5   = %h  (Expected: FFFFFFFB)", result);
        
        // FFFFFFFF * 2
        a = 32'hFFFFFFFF;
        b = 32'd2;
        funct3 = 3'b000;
        #10;
        $display("MUL FFFF*2 = %h  (Expected: FFFFFFFE)", result);
        
        
        // ============================================================
        // MULH
        // ============================================================
        
        a = 32'h80000000;
        b = 32'd2;
        funct3 = 3'b001;
        #10;
        $display("MULH       = %h  (Expected: FFFFFFFF)", result);
        
        // -1 * 2
        a = -32'sd1;
        b = 32'd2;
        funct3 = 3'b001;
        #10;
        $display("MULH -1*2  = %h  (Expected: FFFFFFFF)", result);
        
        // ============================================================
        // MULHSU
        // ============================================================
        
        // -10 * 5
        a = -32'sd10;
        b = 32'd5;
        funct3 = 3'b010;
        #10;
        $display("MULHSU      = %h  (Expected: FFFFFFFF)", result);
        
        // -1 * unsigned 2
        a = 32'hFFFFFFFF;
        b = 32'd2;
        funct3 = 3'b010;
        #10;
        $display("MULHSU -1*2 = %h  (Expected: FFFFFFFF)", result);
        
        // ============================================================
        // MULHU
        // ============================================================
        
        a = 32'hFFFFFFFF;
        b = 32'd2;
        funct3 = 3'b011;
        #10;
        $display("MULHU       = %h  (Expected: 00000001)", result);
        
        // Maximum unsigned multiplication
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        funct3 = 3'b011;
        #10;
        $display("MULHU MAX   = %h  (Expected: FFFFFFFE)", result);
        
        
        // ============================================================
        // SIGNED DIVISION
        // ============================================================
        
        a = -32'sd20;
        b = 32'sd5;
        funct3 = 3'b100;
        #10;
        $display("DIV -20/5   = %0d  (Expected: -4)", $signed(result));
        
        // -1 / 1
        a = -32'sd1;
        b = 32'sd1;
        funct3 = 3'b100;
        #10;
        $display("DIV -1/1    = %0d  (Expected: -1)", $signed(result));
        
        // 1 / -1
        a = 32'sd1;
        b = -32'sd1;
        funct3 = 3'b100;
        #10;
        $display("DIV 1/-1    = %0d  (Expected: -1)", $signed(result));
        
        // -1 / -1
        a = -32'sd1;
        b = -32'sd1;
        funct3 = 3'b100;
        #10;
        $display("DIV -1/-1   = %0d  (Expected: 1)", $signed(result));
        
        // 0 / 5
        a = 32'd0;
        b = 32'd5;
        funct3 = 3'b100;
        #10;
        $display("DIV 0/5     = %0d  (Expected: 0)", $signed(result));
        
        
        // ============================================================
        // UNSIGNED DIVISION
        // ============================================================
        
        a = 32'd20;
        b = 32'd5;
        funct3 = 3'b101;
        #10;
        $display("DIVU 20/5   = %0d  (Expected: 4)", result);
        
        // FFFFFFFF / 1
        a = 32'hFFFFFFFF;
        b = 32'd1;
        funct3 = 3'b101;
        #10;
        $display("DIVU MAX/1  = %h  (Expected: FFFFFFFF)", result);
        
        // FFFFFFFF / 2
        a = 32'hFFFFFFFF;
        b = 32'd2;
        funct3 = 3'b101;
        #10;
        $display("DIVU MAX/2  = %h  (Expected: 7FFFFFFF)", result);
        
        
        // ============================================================
        // SIGNED REMAINDER
        // ============================================================
        
        a = -32'sd21;
        b = 32'sd5;
        funct3 = 3'b110;
        #10;
        $display("REM -21%5   = %0d  (Expected: -1)", $signed(result));
        
        // -1 % 5
        a = -32'sd1;
        b = 32'sd5;
        funct3 = 3'b110;
        #10;
        $display("REM -1%5    = %0d  (Expected: -1)", $signed(result));
        
        // 1 % -5
        a = 32'sd1;
        b = -32'sd5;
        funct3 = 3'b110;
        #10;
        $display("REM 1%-5    = %0d  (Expected: 1)", $signed(result));
        
        // 0 % 5
        a = 32'd0;
        b = 32'd5;
        funct3 = 3'b110;
        #10;
        $display("REM 0%5     = %0d  (Expected: 0)", $signed(result));
        
        
        // ============================================================
        // UNSIGNED REMAINDER
        // ============================================================
        
        a = 32'd21;
        b = 32'd5;
        funct3 = 3'b111;
        #10;
        $display("REMU 21%5   = %0d  (Expected: 1)", result);
        
        // FFFFFFFF % 2
        a = 32'hFFFFFFFF;
        b = 32'd2;
        funct3 = 3'b111;
        #10;
        $display("REMU MAX%2  = %h  (Expected: 00000001)", result);
        
        
        // ============================================================
        // DIVISION BY ZERO
        // ============================================================
        
        a = 32'd20;
        b = 32'd0;
        funct3 = 3'b100;
        #10;
        $display("DIV0        = %h  (Expected: FFFFFFFF)", result);
        
        // DIVU by zero
        funct3 = 3'b101;
        #10;
        $display("DIVU0       = %h  (Expected: FFFFFFFF)", result);
        
        // REM by zero
        funct3 = 3'b110;
        #10;
        $display("REM0        = %h  (Expected: 00000014)", result);
        
        // REMU by zero
        funct3 = 3'b111;
        #10;
        $display("REMU0       = %h  (Expected: 00000014)", result);
        
        
        // ============================================================
        // SIGNED DIVISION OVERFLOW
        // INT_MIN / -1
        // ============================================================
        
        a = 32'h80000000;
        b = 32'hFFFFFFFF;
        funct3 = 3'b100;
        #10;
        $display("DIV OVERFLOW = %h  (Expected: 80000000)", result);
        
        // Corresponding remainder must be zero
        funct3 = 3'b110;
        #10;
        $display("REM OVERFLOW = %h  (Expected: 00000000)", result);
        
        
        $finish;
    end

endmodule