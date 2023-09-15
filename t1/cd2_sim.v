`timescale 1ns / 1ps


module cd2_sim();
    reg clk1_s = 0;
    reg clk2_s = 0;
    reg A_s;
    
    wire [11:0] value_s;
    wire valid_s;
    
    always #1805 clk1_s = ~clk1_s;    //277 MHz - 3610 ps
    always #4854 clk2_s = ~clk2_s;    //103 MHz - 9708 ps
    
    reg[31:0] i = 1000;
    
    initial
    begin
    
        repeat(2000)
        begin
            A_s <= 0;
            #i;
            A_s <= 1;
            #4000;
            
            i <= i * 2;
            if (i == 0) i <= 1000;
        end
    
    end
    
    cd2 cd2_1(
        .clk1(clk1_s),
        .clk2(clk2_s),
        .A(A_s),
        
        .value(value_s),
        .valid(valid_s)
    );
    
endmodule
