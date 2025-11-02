`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 10:12:59 AM
// Design Name: 
// Module Name: cpg_top
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


module cpg_top(input logic clk,
                input logic rst,
                input logic trigger,    // start pulse generation
                input logic override,   // override the pulse
                input logic [11:0] high_time_cfg,
                input logic [11:0] low_time_cfg,
                input logic [5:0] pulse_count_cfg,
                output logic [11:0] measured_high_time,
                output logic [11:0] measured_low_time,
                output logic pulse_out
    );
                // output logic [11:0] measured_pulse_count,

    // logic [11:0] high_time_count;
    // logic [11:0] low_time_count;
    // logic [11:0] pulse_count;
    logic pulse_signal;
    
    // assign measured_high_time = high_time_count;
    // assign measured_low_time = low_time_count;
    // assign measured_pulse_count = pulse_count;
    assign pulse_out = pulse_signal;

    // Instantiate the configurable pulse generator
    conf_pulse_generator cpg_inst (
        .i_lowtime(low_time_cfg),
        .i_hightime(high_time_cfg),
        .i_cycles(pulse_count_cfg),
        .i_trigger(trigger),
        .i_override(override),
        .i_clk(clk),
        .i_rst(rst),
        .o_pulse(pulse_signal)
    );

    // Instantiate the Pulse On time Measurement Module
    high_time_count htc_inst (
        .pulse(pulse_signal),
        .clk(clk),
        .rst(rst),
        .o_hightime(measured_high_time),
        .o_lowtime(measured_low_time)
    );
        // .pulse_count(pulse_count)

    // Instantiate the low time measurement module
    // low_time_count ltc_inst (
    //     .pulse(pulse_signal),
    //     .clk(clk),
    //     .rst(rst),
    //     .o_lowtime(measured_low_time)
    // );

endmodule
