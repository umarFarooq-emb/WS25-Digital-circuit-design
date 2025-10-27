`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FH JOANNEUM
// Engineer: Umer Farooq
// 
// Create Date: 10/20/2025 10:04:16 PM
// Design Name: 
// Module Name: interlocked_counter_top
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


module interlocked_counter_top(input clk, set2max,
                output logic [1:0] down_count_out,
                output [4:0] up_count_out
    );

    // Create shared signal
    logic up_count_enable;
    logic down_count_enable;
    logic up_cnt_reset;

    // Enable logic of the counters
    assign down_count_enable = (up_count_out >= 5'd16) ? 1'b1 : 1'b0;
    assign up_count_enable = (down_count_out > 1'b0) ? 1'b1 : 1'b0;
    
    // Reset logic of the up counter
    assign up_cnt_reset = set2max | down_count_enable;

    // Instantiate the down counter
    down_counter dut_down (
        .clk(clk),
        .enable(down_count_enable),   //connect the shared signal
        .set2max(set2max),
        .count_out(down_count_out)
    );

    // Instantiate the up counter
    up_counter dut_up (
        .clk(clk),
        .reset(up_cnt_reset),
        .enable(up_count_enable),    //connect the shared signal
        .count_out(up_count_out)
    );

endmodule
