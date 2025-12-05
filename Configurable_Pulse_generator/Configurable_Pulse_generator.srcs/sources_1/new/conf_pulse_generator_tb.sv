`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FH Joanneum
// Engineer: Umer Farooq
// 
// Create Date: 10/31/2025 02:06:11 AM
// Design Name: Testbench for Configurable Pulse Generator
// Module Name: conf_pulse_generator_tb
// Project Name: Configurable Pulse Generator
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


module conf_pulse_generator_tb();

    // Testbench Signals
    logic [11:0] tb_lowtime;
    logic [11:0] tb_hightime;
    logic [5:0] tb_cycles; // number of cycles to generate
    logic tb_trigger;
    logic tb_override;
    logic tb_clk;
    logic tb_rst;
    logic tb_pulse;
    logic [11:0] tb_measured_hightime;
    logic [11:0] tb_measured_lowtime;
    logic [11:0] tb_measured_pulsecount;

    // Define the five (hightime, lowtime) configurations from the assignment
    logic [11:0] hts [0:4];
    logic [11:0] lts [0:4];

    // Loop variables
    int cfg_idx;
    int wait_cycles;

    // cycle list when the ovverride is deasserted
    int cycles_list [0:2] = '{1,3,6};
    int run_i;

    // Instantiate the top level module
    cpg_top top_inst (
        .clk(tb_clk),
        .rst(tb_rst),
        .trigger(tb_trigger),
        .override(tb_override),
        .high_time_cfg(tb_hightime),
        .low_time_cfg(tb_lowtime),
        .pulse_count_cfg(tb_cycles),
        .measured_high_time(tb_measured_hightime),
        .measured_low_time(tb_measured_lowtime),
        .measured_pulse_count(tb_measured_pulsecount),
        .pulse_out(tb_pulse)
    );

    // Clock Generation
    initial begin
        tb_clk = 0;
        forever #5 tb_clk = ~tb_clk; // 10ns clock period
    end

    // Reset Task
    task automatic apply_reset();
        tb_rst = 0;
        repeat (1) @(posedge tb_clk);
        tb_rst = 1;
        @(posedge tb_clk);
    endtask

    
    /**
      *  Self check tasks for high time, low time and total pulse count
      */
    int total_tests;
    int test_success_count = 0;
    int test_failure_count = 0;
    logic [11:0] expected_pulsecnt = 0;

    task automatic self_check_time(input [11:0] expected_high,
                                input [11:0] expected_low);

        int set_cycles = tb_hightime + tb_lowtime;  // margin
        repeat (set_cycles) @(posedge tb_clk);

        assert (tb_measured_hightime == expected_high) test_success_count++;
            else begin
                $error("High time mismatch: Expected=0x%0h, Measured=0x%0h",
                        expected_high, tb_measured_hightime);
                test_failure_count++;
            end

        assert (tb_measured_lowtime == expected_low) test_success_count++;
            else begin
                $error("Low time mismatch: Expected=0x%0h, Measured=0x%0h",
                        expected_low, tb_measured_lowtime);
                test_failure_count++;
            end
    endtask

    task automatic self_check_pulsecount(input [11:0] expected_pulsecnt);
        assert(tb_measured_pulsecount == expected_pulsecnt) test_success_count++;
            else begin
                $error("Pulse count mismatch: Expected=%0d, Measured=%0d",
                        expected_pulsecnt, tb_measured_pulsecount);
                test_failure_count++;
            end
    endtask
    

    always @(posedge tb_pulse) begin
        expected_pulsecnt = expected_pulsecnt + 1;
    end

    always @(posedge tb_pulse, negedge tb_pulse) begin
        self_check_time(tb_hightime, tb_lowtime);
        self_check_pulsecount(expected_pulsecnt);
    end

    assign total_tests = test_success_count + test_failure_count;

    // Self test tasks end.

    /**
      * Test Sequence
      */
    initial begin
        // Initialize Inputs and reset
        tb_lowtime = 12'd0;
        tb_hightime = 12'd0;
        tb_cycles = 6'd0;
        tb_trigger = 1'b0;
        tb_override = 1'b0;
        
        apply_reset();

        hts = '{12'h19A, 12'h4CD, 12'h800, 12'hB33, 12'hE66};
        lts = '{12'hE66, 12'hB33, 12'h800, 12'h4CD, 12'h19A};

        // Release reset
        #15;
        tb_rst = 1'b0;

        // 1) Keep override asserted for the first set of tests (i_override = 1)
        tb_override = 1'b1;
        tb_cycles = 6'd0; // ignored when override is asserted

        for (cfg_idx = 0; cfg_idx < 5; cfg_idx = cfg_idx + 1) begin
            tb_hightime = hts[cfg_idx];
            tb_lowtime  = lts[cfg_idx];

            $display("\n[OVERRIDE=1] Test %0d: i_hightime=0x%0h i_lowtime=0x%0h", cfg_idx, tb_hightime, tb_lowtime);

            // trigger
            tb_trigger = 1'b1;
            @(posedge tb_clk);
            tb_trigger = 1'b0;

            // Wait a few pulses to observe behaviour
            wait_cycles = (tb_hightime + tb_lowtime) * 3; // observe ~3 pulses worth
            if (wait_cycles < 100) wait_cycles = 100; // minimum observation
            repeat (wait_cycles) @(posedge tb_clk);
        end

        // 2) Deassert override and rerun all tests three times with i_cycles = 1, 3, 6
        tb_override = 1'b0;

        for (run_i = 0; run_i < 3; run_i = run_i + 1) begin
            tb_cycles = cycles_list[run_i];
            for (cfg_idx = 0; cfg_idx < 5; cfg_idx = cfg_idx + 1) begin
                tb_hightime = hts[cfg_idx];
                tb_lowtime  = lts[cfg_idx];

                $display("\n[OVERRIDE=0] Run %0d cycles=%0d Test %0d: i_hightime=0x%0h i_lowtime=0x%0h", run_i+1, tb_cycles, cfg_idx, tb_hightime, tb_lowtime);

                // trigger
                tb_trigger = 1'b1;
                @(posedge tb_clk);
                tb_trigger = 1'b0;

                // Wait enough cycles for the requested number of pulses plus margin
                wait_cycles = (tb_hightime + tb_lowtime) * (tb_cycles + 2) + 50;
                if (wait_cycles < 100) wait_cycles = 100;
                repeat (wait_cycles) @(posedge tb_clk);
            end
        end

        // $display("\nAll 20 manual tests completed.");
        $display("================================");
        $display("Total Tests Run: %0d", total_tests);
        $display("Total Successes: %0d", test_success_count);
        $display("Total Failures:  %0d", test_failure_count);
        $display("================================\n");
        $finish;
    end

endmodule
