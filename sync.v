`timescale 1ns / 1ps


module sync(
    input clk,
    input rst,
    
    input wire EN_1,
    input wire EN_2,
    
    input wire [7:0] src_data1,   
    input wire       src_last1,
    input wire       src_ready1,
        
    input wire [7:0] src_data2,
    input wire       src_last2,        
    input wire       src_ready2,

    output reg [7:0] sink_data1,
    output reg       sink_valid1,
    output reg       sink_last1, 
    
    output reg [7:0] sink_data2,
    output reg       sink_valid2,
    output reg       sink_last2
    );
    reg [7:0] STATE = 0;
    
    reg       ena_1 = 0;
    reg       wea_1 = 0;
    reg  [7:0] addra_1 = 0;
    reg  [7:0] NEXTaddra_1 = 0;
    reg  [7:0] dina_1 = 0;
    wire [7:0] douta_1;
    
    reg       ena_2 = 0;
    reg       wea_2 = 0;
    reg  [7:0] NEXTaddra_2 = 0;
    reg  [7:0] addra_2 = 0;
    reg  [7:0] dina_2 = 0;
    wire [7:0] douta_2;
    
    reg [7:0] ds1_lenght = 0;
    reg [7:0] ds2_lenght = 0;
    
    reg [7:0] ds1_count_packs = 0;
    reg [7:0] ds2_count_packs = 0;
    
    reg last1 = 0;
    reg last2 = 0;
    always @(posedge clk)
    begin
        case(STATE)
            0:  //get data
            begin
                ena_1 <= 0;
                wea_1 <= 0;
                ena_2 <= 0;
                wea_2 <= 0;
                
                if (EN_1 == 1)
                begin
                    ena_1 <= 1;
                    wea_1 <= 1;
                    NEXTaddra_1 <= NEXTaddra_1 + 1;
                    addra_1 <= NEXTaddra_1;
                    dina_1 <= src_data1;  
                end

                if (EN_2 == 1)
                begin
                    ena_2 <= 1;
                    wea_2 <= 1;
                    NEXTaddra_2 <= NEXTaddra_2 + 1;
                    addra_2 <= NEXTaddra_2;
                    dina_2 <= src_data2; 
                end
                
                if (src_last1 == 1) last1 <= 1;
                if (src_last2 == 1) last2 <= 1;
                
                
                if ((last1 == 1) && (last2 == 1))
                begin
                    ds1_lenght <= addra_1 + 1;
                    ds2_lenght <= addra_2 + 1;
                
                    last1 <= 0;
                    last2 <= 0;
                
                    ena_1 <= 0;
                    wea_1 <= 0;
                    ena_2 <= 0;
                    wea_2 <= 0;
                    
                    NEXTaddra_1 <= 0;
                    NEXTaddra_2 <= 0;
                    addra_1 <= 0;
                    addra_2 <= 0;
                    
                    STATE <= 1;
                end
            end
            
            1:  //wait valids from DS
            begin
                if ((src_ready1 == 1) && (src_ready2 == 1))
                begin
                    ena_1 <= 1;
                    ena_2 <= 1;
                    STATE <= 2;
                end
            end
            
            2:  //transmit sync data
            begin                
                //================== DS 1 ==================//
                sink_data1 <= douta_1;
                addra_1 <= addra_1 + 1;
                ds1_count_packs <= ds1_count_packs + 1;
                if (ds1_count_packs >= (ds1_lenght - 1))
                begin
                    sink_last1 <= 1;
                end
                
                if (sink_last1 == 1)
                begin
                    ena_1 <= 0;
                end
                //==========================================//
                
                //================== DS 2 ==================//
                sink_data2 <= douta_2;
                addra_2 <= addra_2 + 1;
                ds2_count_packs <= ds2_count_packs + 1;
                if (ds2_count_packs >= (ds2_lenght - 1))
                begin
                    sink_last2 <= 1;
                end
                if (sink_last2 == 1)
                begin
                    ena_2 <= 0;
                end
                //==========================================//
                
                if ((ena_1 == 0) && (ena_2 == 0))
                begin           
                    ds1_count_packs <= 0;
                    ds2_count_packs <= 0;
                    
                    sink_last1 <= 0;
                    sink_last2 <= 0;
                    
                    addra_1 <= 0;
                    addra_2 <= 0;
                    sink_valid1 <= 1;
                    sink_valid2 <= 1;
                    STATE <= 3;
                end

            end
            
            3: 
            begin
                sink_valid1 <= 0;
                sink_valid2 <= 0;
                STATE <= 0;
            end
        endcase
    end
    
//     sink_valid1,
//    sink_last1,
//    src_ready1,
    
    
    ram ram_ds1 (
      .clka(clk),    // input wire clka
      .ena(ena_1),      // input wire ena
      .wea(wea_1),      // input wire [0 : 0] wea
      .addra(addra_1),  // input wire [7 : 0] addra
      .dina(dina_1),    // input wire [7 : 0] dina
      .douta(douta_1)  // output wire [7 : 0] douta
    );

    ram ram_ds2 (
      .clka(clk),    // input wire clka
      .ena(ena_2),      // input wire ena
      .wea(wea_2),      // input wire [0 : 0] wea
      .addra(addra_2),  // input wire [7 : 0] addra
      .dina(dina_2),    // input wire [7 : 0] dina
      .douta(douta_2)  // output wire [7 : 0] douta
    );
endmodule
