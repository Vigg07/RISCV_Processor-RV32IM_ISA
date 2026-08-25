`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: mul_div_unit
// Project Name: rv32im_single_cycle 
//////////////////////////////////////////////////////////////////////////////////

module mul_div_unit(
    input [31:0] a,b,
    input [2:0] funct3,
    
    output reg [31:0] result
    );
    
    reg signed [63:0] mul_ss;
    reg signed [63:0] mul_su;
    reg [63:0] mul_uu;
    
    always @(*) begin   
        
        mul_ss = $signed(a) * $signed(b);
        mul_su = $signed(a) * $signed({32'b0, b});
        mul_uu = a * b;
        
        case(funct3)
        
            3'b000 : result = mul_ss[31:0];  //MUL
             
            3'b001 : result = mul_ss[63:32]; //MULH
            
            3'b010 : result = mul_su[63:32]; //MULHSU
            
            3'b011 : result = mul_uu[63:32]; //MULHU
            
            3'b100 : begin                   // DIV
                if(b == 32'b0)
                    result = 32'hFFFFFFFF;
                else if(a == 32'h80000000 && b == 32'hFFFFFFFF)
                    result = 32'h80000000;
                else
                    result = $signed(a) / $signed(b);
            end
            
            3'b101 : begin                   // DIVU
                if(b == 32'b0)
                    result = 32'hFFFFFFFF;
                else
                    result = a / b;
            end
            
            3'b110 : begin                   // REM
                if (b == 32'b0)
                    result = a;
                else if (a == 32'h80000000 && b == 32'hFFFFFFFF)
                    result = 32'b0;          // RISC-V overflow case
                else
                    result = $signed(a) % $signed(b);
            end
            
            3'b111 : begin                  // REMU
                if(b == 32'b0)
                    result = a;
                else 
                    result = a % b;
            end
            
            default : result = 32'b0;
            
        endcase
    end
    
endmodule
