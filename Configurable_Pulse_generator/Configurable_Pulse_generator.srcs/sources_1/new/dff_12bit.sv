`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 10:15:58 AM
// Design Name: 
// Module Name: dff_12bit
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


module dff_12bit(input clk,
                  input rst,
                  input enable,
                  input [11:0] d,
                  output logic [11:0] q
    );

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            q <= 12'd0;
        end else if (enable) begin
            q <= d;
        end
    end
endmodule
