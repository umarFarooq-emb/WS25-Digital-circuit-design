`timescale 1ns / 1ps

module mycounter_tb ( );
logic clk = 0, reset = 0, ena = 0;
logic [7:0] count;
always #5 clk = ~clk; //create clk

mycounter DUT(
 .clk(clk),
 .reset(reset),
 .enable(ena),
 .cnt(count));
initial
begin
 #26ns;
 reset = 1;
 #50ns;
 reset = 0;
 #50ns;
 ena = 1;
 #200ns;
 $finish;
end
endmodule
