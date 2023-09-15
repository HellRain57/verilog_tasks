`timescale 1ns / 1ps

module DS(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] pack_lenght,    
    input wire ready, 

    output reg valid,   
    output reg EN,   
    output reg [7:0]data,    
    output reg last

);
    reg [7:0] STATE = 0;
    reg [7:0] count_packs = 0;
    reg [7:0] data_gen = 0;
    always @(posedge clk)
    begin
        if(start == 1)
            STATE <= 1;
    
        case(STATE)
            0:  // idling
            begin
            
            end
            
            1: //resetting parameters
            begin
                count_packs <= 0;
                STATE <= 2;
            end
            
            2: //data send
            begin
                data_gen <= data_gen + 1;
                EN <= 1;
                data <= data_gen;
                count_packs <= count_packs + 1;
                if (count_packs >= (pack_lenght - 1))
                begin
                    last <= 1;
                end
                if (last == 1)
                begin
                    last <= 0;
                    EN <= 0;
                    valid <= 1;
                    STATE <= 3;
                end
            end
            
            3:  //wait ready 
            begin
                if ((valid == 1)&&(ready == 1))
                begin
                    valid <= 0;
                    STATE <= 1;
                end
            end
            
        endcase
    end
endmodule
