`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FH JOANNEUM
// Engineer: Umer Farooq
// 
// Create Date: 10/19/2025 11:20:00 PM
// Design Name: 
// Module Name: down_counter
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


module down_counter(input clk, enable, set2max,
                output logic [1:0] count_out
    );
    
    always_ff @(posedge clk) begin
        if (set2max) begin
            count_out <= 2'b11;
        end else if (enable) begin
            count_out <= count_out - 1'b1;
        end
    end
endmodule
