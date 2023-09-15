`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2023 14:46:46
// Design Name: 
// Module Name: top_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_sim( );

    reg clk = 0;
    
    reg rst_1 = 0;
    reg start_1 = 0;
    reg [7:0] pack_lenght_1 = 0;    
    wire ready_1;
    
    wire valid_1;   
    wire [7:0]data_1;   
    wire last_1;
    
    always #5 clk = ~clk;
    
    reg rst_2 = 0;
    reg start_2 = 0;
    reg [7:0] pack_lenght_2 = 0;    
    wire ready_2;
    
    wire valid_2;   
    wire [7:0] data_2;   
    wire last_2;
    
    wire [7:0] sink_data1;
    wire       sink_last1;
    wire [7:0] sink_data2;
    wire       sink_last2;
    
    wire EN_1;
    wire EN_2;
    
    initial
    begin
        #10;
        pack_lenght_1 <= 8;
        pack_lenght_2 <= 8;
        
        start_1 <= 1;
        #10;
        start_1 <= 0;
        
        #50;
        start_2 <= 1;
        #10;
        start_2 <= 0;
        
    end
    
    DS ds_1(
        .clk(clk),
        .rst(rst_1),
        .start(start_1),
        .pack_lenght(pack_lenght_1),    
        .ready(ready_1), 
        .valid(valid_1),
        .EN(EN_1),
        .data(data_1),    
        .last(last_1)
    );
    
    DS ds_2(
        .clk(clk),
        .rst(rst_2),
        .start(start_2),
        .pack_lenght(pack_lenght_2),    
        .ready(ready_2), 
        .valid(valid_2),   
        .EN(EN_2),
        .data(data_2),    
        .last(last_2)
    );
    
    sync sync_1(
        .clk(clk),
        .rst(0),
        
        .EN_1(EN_1),
        .EN_2(EN_2),
        .src_data1(data_1),   
        .src_last1(last_1),
        .src_ready1(valid_1),
            
        .src_data2(data_2),   
        .src_last2(last_2),
        .src_ready2(valid_2),
        
        .sink_data1(sink_data1),
        .sink_valid1(ready_1),
        .sink_last1(sink_last1), 
        
        .sink_data2(sink_data2),
        .sink_valid2(ready_2),
        .sink_last2(sink_last2)
    );
endmodule
