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
                    output logic [11:0] o_lowtime
    );
                    // output logic [11:0] pulse_count

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
    // this is wrong, need to use a counter to count the pulses with the input signal being a clock
    // assign pulse_count = edge_detect;

    // Code for low_time circuit
    logic delayed_pulse_low;
    logic [11:0] lowtime_counter;
    logic edge_detect_low;
    assign edge_detect_low = ~pulse & delayed_pulse_low;
    logic up_counter_rst_low;
    assign up_counter_rst_low = rst | edge_detect;

    dff_1bit dff_inst_low (
        .clk(clk),
        .rst(rst),
        .d(pulse),
        .q(delayed_pulse_low)
    );

    up_counter up_counter_inst (
        .clk(clk),
        .reset(up_counter_rst),
        .enable(pulse),
        .count_out(hightime_counter)
    );

    dff_12bit dff_12bit_inst (
        .clk(edge_detect_low),
        .rst(rst),
        .d(hightime_counter),
        .q(o_hightime)
    );

    up_counter up_counter_inst_low (
        .clk(clk),
        .reset(up_counter_rst_low),
        .enable(~pulse),
        .count_out(lowtime_counter)
    );

    dff_12bit dff_12bit_inst_low (
        .clk(edge_detect),
        .rst(rst),
        .d(lowtime_counter),
        .q(o_lowtime)
    );
endmodule
