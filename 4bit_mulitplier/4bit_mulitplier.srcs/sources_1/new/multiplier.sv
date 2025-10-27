`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FH JOANNEUM
// Engineer: Umer Farooq
// 
// Create Date: 10/19/2025 04:22:38 PM
// Design Name: 
// Module Name: multiplier
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


module multiplier(input [3:0] num_1,
            input [3:0] num_2,
            input en,
            output logic [7:0] mul_out
    );

    /** Multiply when enabled is high, else output zero 
      * Tested Works fine
      * TODO Work on the assert feature of testbench
      */
    // assign mul_out = en ? (num_1 * num_2) : 8'b0;

    // declaration of logics inside the module for the unsigned bit extension
    logic [7:0] partial_product_0 = 8'b0;
    logic [7:0] partial_product_1 = 8'b0;
    logic [7:0] partial_product_2 = 8'b0;
    logic [7:0] partial_product_3 = 8'b0;

    always_comb begin
        if (~en) begin
            mul_out = 8'b0;
        end else begin
            // Partial products generation
            partial_product_0 = {4'b0000, (num_1 & {4{num_2[0]}})} << 0;
            partial_product_1 = {4'b0000, (num_1 & {4{num_2[1]}})} << 1;
            partial_product_2 = {4'b0000, (num_1 & {4{num_2[2]}})} << 2;
            partial_product_3 = {4'b0000, (num_1 & {4{num_2[3]}})} << 3;

            // Final multiplication
            mul_out = partial_product_0 + partial_product_1 + partial_product_2 + partial_product_3;
        end
    end
    
endmodule
