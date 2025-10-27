`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FH JOANNEUM
// Engineer: Umer Farooq
// 
// Create Date: 10/19/2025 04:22:38 PM
// Design Name: 
// Module Name: multiplier_tb
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


module multiplier_tb();

    // Inputs
    logic [3:0] num_a;
    logic [3:0] num_b;
    logic en;
    // Outputs
    logic [7:0] mul_result;

    // Instantiate the Unit Under Test (UUT)
    multiplier uut (
        .num_1(num_a),
        .num_2(num_b),
        .en(en),
        .mul_out(mul_result)
    );

    initial begin
        //  Initialize Inputs
        en = 0;
        num_a = 4'b0000;
        num_b = 4'b0000;
        #1
        assert (mul_result == 8'b00000000) else $error("Testcase 1 Failed: Expected 0, Got %0d", mul_result);
        #10;
        en = 1;
        num_a = 4'b0011; // 3
        num_b = 4'b0101; // 5
        #1
        assert (mul_result == 8'b00001111) else $error("Testcase 2 Failed: Expected 15, Got %0d", mul_result);
        #10;
        num_a = 4'b1111; // 15
        num_b = 4'b1111; // 15
        #1
        assert (mul_result == 8'b11100001) else $error("Testcase 3 Failed: Expected 225, Got %0d", mul_result);
        #10;
        num_a = 4'b1001; // 9
        num_b = 4'b0011; // 3
        #1
        assert (mul_result == 8'b00011011) else $error("Testcase 4 Failed: Expected 27, Got %0d", mul_result);
        #10;
        num_a = 4'b0110; // 6
        num_b = 4'b0100; // 4
        #1
        assert (mul_result == 8'b00011000) else $error("Testcase 5 Failed: Expected 0, Got %0d", mul_result);
        #10;
        $stop;
    end
endmodule
