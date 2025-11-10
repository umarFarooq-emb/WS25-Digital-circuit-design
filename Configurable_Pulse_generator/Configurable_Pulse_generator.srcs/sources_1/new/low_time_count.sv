`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 10:11:53 AM
// Design Name: 
// Module Name: low_time_count
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


module low_time_count(input logic pulse,
                      input logic clk,
                      input logic rst,
                      output logic [11:0] o_lowtime
    );

    logic delayed_pulse;
    logic [11:0] lowtime_counter;

    dff_1bit dff_inst (
        .clk(clk),
        .rst(rst),
        .d(pulse),
        .q(delayed_pulse)
    );

    logic edge_detect;
    assign edge_detect = ~pulse & delayed_pulse;
    logic up_counter_rst;
    assign up_counter_rst = rst | edge_detect;

    up_counter up_counter_inst (
        .clk(clk),
        .reset(up_counter_rst),
        .enable(~pulse),
        .count_out(lowtime_counter)
    );

    dff_12bit dff_12bit_inst (
        .clk(clk),
        .rst(rst),
        .enable(edge_detect),
        .d(lowtime_counter),
        .q(o_lowtime)
    );

endmodule
