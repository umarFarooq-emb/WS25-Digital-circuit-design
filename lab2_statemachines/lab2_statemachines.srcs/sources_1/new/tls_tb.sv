`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2025 09:56:23 PM
// Design Name: 
// Module Name: tls_tb
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


module tls_tb();

    // Testbench signals
    logic tb_button;
    logic tb_clk;
    logic tb_rst;
    logic tb_stop;
    logic tb_walk;
    logic tb_red;
    logic tb_yellow;
    logic tb_green;
    logic [7:0] tb_stime;
    logic tb_set;
    logic tb_expired;
    logic tb_fsmstep;
    logic [3:0] tb_timer_count;
    logic [7:0] tb_target_sec;
    logic [7:0] tb_sec_counter;
    logic tb_running;

    // Instantiate the top module
    top_mod uut (
        .i_button(tb_button),
        .i_clk(tb_clk),
        .i_rst(tb_rst),
        .o_stop(tb_stop),
        .o_walk(tb_walk),
        .o_red(tb_red),
        .o_yellow(tb_yellow),
        .o_green(tb_green),
        .stime_sig(tb_stime),
        .set_sig(tb_set),
        .expired_sig(tb_expired),
        .fsmstep_sig(tb_fsmstep),
        .timer_count(tb_timer_count),
        .target_sec(tb_target_sec),
        .sec_counter(tb_sec_counter),
        .running(tb_running)
    );

    // Clock generation
    initial begin
        tb_clk = 1;
        forever #5 tb_clk = ~tb_clk; // 10 ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        tb_button = 0;
        tb_rst = 1;

        // Release reset after some time
        #15;
        tb_rst = 0;

        // Simulate button press
        #50;
        tb_button = 1;
        #10;
        tb_button = 0;

        #50;
        tb_button = 1;
        #10;
        tb_button = 0;
        // Run simulation for a while
        #8000;
        tb_button = 1;
        #10;

        // Finish simulation
        $finish;
    end
endmodule
