`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FH Joanneum
// Engineer: Umer Farooq
// 
// Create Date: 12/04/2025 08:58:05 PM
// Design Name: 
// Module Name: top_mod
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


module top_mod(
        input i_button,
        input i_clk,
        input i_rst,
        output o_stop,
        output o_walk,
        output o_red,
        output o_yellow,
        output o_green,
        output [7:0] stime_sig,
        output set_sig,
        output expired_sig,
        output fsmstep_sig,
        output [3:0] timer_count,
        output [7:0] target_sec,
        output [7:0] sec_counter,
        output running
    );

    // Define the signals to connect to the traffic_light_SM instance and to the timer.
    logic expired_sig;
    logic fsmstep_sig;
    logic [7:0] stime_sig;
    logic set_sig;
    logic [3:0] timer_count;
    logic [7:0] target_sec;
    logic [7:0] sec_counter;
    logic running;

    traffic_light_SM traffic_light_SM_inst (
        .i_button(i_button),
        .i_expired(expired_sig),
        .i_fsmstep(fsmstep_sig),
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_stop(o_stop),
        .o_walk(o_walk),
        .o_red(o_red),
        .o_yellow(o_yellow),
        .o_green(o_green),
        .o_stime(stime_sig),
        .o_set(set_sig)
    );

    always_ff @(posedge i_clk, posedge i_rst) begin
        if (i_rst) begin
            running <= 0;
            sec_counter <= 0;
            expired_sig <= 0;
            timer_count <= 0;
        end else begin
            // FSM starts a new timer
            if (set_sig) begin
                running <= 1;
                sec_counter <= 0;
                target_sec <= stime_sig;
                timer_count <= 0;
            end

            if (running) begin
                if (timer_count == 10) begin   // 10 cycles = 1 second in simulation
                    timer_count <= 0;
                    sec_counter <= sec_counter + 1;
                    fsmstep_sig <= 1;

                    if (sec_counter == target_sec) begin
                        expired_sig <= 1;
                        running <= 0;
                    end
                end else begin
                    timer_count <= timer_count + 1;
                    fsmstep_sig <= 0;
                end
            end else begin
                expired_sig <= 0;
                fsmstep_sig <= 0;
            end
        end
    end
endmodule
