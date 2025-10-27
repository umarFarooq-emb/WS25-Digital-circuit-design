`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FH JOANNEUM
// Engineer: Umer Farooq
// 
// Create Date: 10/19/2025 11:20:00 PM
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
                output logic [4:0] count_out
    );

    logic [4:0] count_out;

    always_ff @(posedge clk) begin
        if (reset) begin
            count_out <= 5'b00000;
        end else if (enable) begin
            count_out <= count_out + 1;
        end
    end

endmodule
