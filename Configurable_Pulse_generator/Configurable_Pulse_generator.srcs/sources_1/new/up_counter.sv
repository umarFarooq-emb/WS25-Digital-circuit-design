`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 10:03:17 AM
// Design Name: 
// Module Name: up_counter
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


module up_counter(input clk, reset, enable,
                output logic [11:0] count_out
    );

    logic [11:0] count_out;

    always_ff @(posedge clk) begin
        if (reset) begin
            count_out <= 12'd0;
        end else if (enable) begin
            count_out <= count_out + 1;
        end
    end
endmodule
