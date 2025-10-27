`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2025 01:00:55 AM
// Design Name: 
// Module Name: value_compare_tb
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


module value_compare_tb();
logic in_A, in_B, oen;
logic out_AltB, out_AbtB, out_AeqB;

compare uut(.A(in_A),
        .B(in_B),
        .en(oen),
        .AltB(out_AltB),
        .AbtB(out_AbtB),
        .AeqB(out_AeqB)
        );

initial begin
    oen = 1'b0;
    #20ns;
    oen = 1'b1;

    in_A = 1'b0;
    in_B = 1'b0;
    #20ns;

    assert (out_AeqB)
        else $fatal("Logic failed for both inputs at logical level '0'");

//    if (~out_AeqB) begin
//        $error("Logic failed for both inputs at logical level '0'");
//    end

    in_A = 1'b0;
    in_B = 1'b1;
    #20ns;
    
    assert(out_AltB)
        else $fatal("Logic failed for A at logical level '0' and B at logical level '1'");

//    if (~out_AltB) begin
//        $error("Logic failed for A at logical level '0' and B at logical level '1'");
//    end

    in_A = 1'b1;
    in_B = 1'b0;
    #20ns;

    assert(out_AbtB)
        else $fatal("Logic failed for A at logical level '1' and B at logical level '0'");

//    if (~out_AbtB) begin
//        $error("Logic failed for A at logical level '1' and B at logical level '0'");
//    end

    in_A = 1'b1;
    in_B = 1'b1;
    #20ns;

    assert(out_AeqB)
        else $fatal("Logic failed for both inputs at logical level '1'");

//    if (~out_AeqB) begin
//        $error("Logic failed for both inputs at logical level '1'");
//    end

    $display("Test Passed");
    $finish;
end

endmodule
