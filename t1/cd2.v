`timescale 1ns / 1ps

module cd2(
    input wire clk1,
    input wire clk2,
    input wire A,
    
    output reg [11:0] value,
    output reg valid
);
    reg [15:0] i = 0;
    reg [11:0] val_A = 0;
    
    always @(posedge clk1)
    begin
        if (A == 1)
        begin
            val_A <= val_A + 1;
        end
    end
    
    always @(posedge clk2)
    begin
        valid <= 0;
        i <= i + 1;
        if (i >= 999)
        begin
            i <= 0;
            value <= val_A;
            valid <= 1;
            val_A <= 0;
        end
    end
    
    initial
    begin
        value <= 0;
        valid <= 0;
    end
endmodule
