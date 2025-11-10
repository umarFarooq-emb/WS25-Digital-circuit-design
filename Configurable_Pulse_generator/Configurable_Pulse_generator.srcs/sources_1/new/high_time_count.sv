`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 10:12:25 AM
// Design Name: 
// Module Name: high_time_count
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


module high_time_count(input logic pulse,
                    input logic clk,
                    input logic rst,
                    output logic [11:0] o_hightime,
                    output logic [11:0] o_pulsecnt
    );

    logic delayed_pulse;
    logic [11:0] hightime_counter;

    dff_1bit dff_inst (
        .clk(clk),
        .rst(rst),
        .d(pulse),
        .q(delayed_pulse)
    );

    logic edge_detect;
    assign edge_detect = pulse & ~delayed_pulse;
    logic up_counter_rst;
    assign up_counter_rst = rst | edge_detect;

    // Instatiate the pulse counter
    up_counter pulse_cnt(
        .clk(clk),
        .reset(rst),
        .enable(edge_detect),
        .count_out(o_pulsecnt)
    );
    
    up_counter up_counter_inst (
        .clk(clk),
        .reset(up_counter_rst),
        .enable(pulse),
        .count_out(hightime_counter)
    );

    dff_12bit dff_12bit_inst (
        .clk(clk),
        .rst(rst),
        .enable(edge_detect),
        .d(hightime_counter),
        .q(o_hightime)
    );
endmodule
