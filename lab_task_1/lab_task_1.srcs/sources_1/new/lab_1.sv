`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2025 09:04:34 AM
// Design Name: 
// Module Name: lab_1
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

module mystery_module(
 input [3:0] din,
 output logic [1:0] dout
 );

 always_comb
 begin
 case (din)
 1 : dout = 2'b00;
 2 : dout = 2'b01;
 4 : dout = 2'b10;
 8 : dout = 2'b11;
 
 default: /* already 'b00 */;
 endcase
 end

endmodule
