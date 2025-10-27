`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FH JOANNEUM
// Engineer: Umer Farooq
// 
// Create Date: 10/19/2025 11:20:00 PM
// Design Name: 
// Module Name: up_down_counter_tb
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

module up_down_counter_tb();

    logic clk;
    logic A;
    logic [1:0] B;
    logic [4:0] up_count_out;
    
    always #5 clk = ~clk;

    /**
      * Enable the following code to check the individual reset and enable
      * signals of the individual counters that are interlocked.
      * If the following logic is enabled then remove the instantiation of the top module.
      */

    // logic [1:0] down_count_out;
    // logic [4:0] up_count_out;

    // Create shared signal
    // logic up_count_enable;
    // logic down_count_enable;
    // logic up_cnt_reset;


    // assign down_count_enable = (up_count_out >= 5'd16) ? 1'b1 : 1'b0;
    // assign up_count_enable = (down_count_out > 1'b0) ? 1'b1 : 1'b0;
    // assign up_cnt_reset = set2max | down_count_enable;

    // down_counter dut_down (
    //     .clk(clk),
    //     .enable(down_count_enable),   //connect the shared signal
    //     .set2max(set2max),
    //     .count_out(down_count_out)
    // );

    // up_counter dut_up (
    //     .clk(clk),
    //     .reset(up_cnt_reset),
    //     .enable(up_count_enable),    //connect the shared signal
    //     .count_out(up_count_out)
    // );

    interlocked_counter_top dut (
        .clk(clk),
        .set2max(A),
        .down_count_out(B),
        .up_count_out(up_count_out)        
    );

    initial begin
        // Initialize signals
        clk = 0;
        A = 0;

        #5ns
        A = 1;  // Set down counter to max value
        
        #5ns
        A = 0;  // Release set2max
        // Finish simulation
    end
endmodule
