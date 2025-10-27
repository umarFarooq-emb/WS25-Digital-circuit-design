`timescale 1ns/1ps
module lab_1_tb;

    logic [3:0] data_in;
    logic [1:0] data_out;

    mystery_module DUT (
        .din (data_in),
        .dout(data_out)
    );

    initial begin
        // Initialize inputs so the first evaluation isn't X
        data_in = 4'd0;

        #20ps data_in = 4'd1;
        #20ps data_in = 4'd2;
        #20ps data_in = 4'd4;
        #20ps data_in = 4'd8;

        #20ps $finish;
    end

endmodule
