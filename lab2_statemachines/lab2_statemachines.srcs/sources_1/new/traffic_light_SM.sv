`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2025 08:08:34 PM
// Design Name: 
// Module Name: traffic_light_SM
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


module traffic_light_SM(
        input i_button,
        input i_expired,
        input i_fsmstep,
        input i_clk,
        input i_rst,
        output logic o_stop,
        output logic o_walk,
        output logic o_red,
        output logic o_yellow,
        output logic o_green,
        output logic [7:0] o_stime,
        output logic o_set
    );

    // State encoding
    typedef enum logic [1:0] {
        S_WALK = 2'b000,    // people walk  (pedestrian green)
        S_RED = 2'b001,     // vehicle red
        S_YELLOW = 2'b010,  // vehicle yellow
        S_GREEN = 2'b011    // vehicle green
    } state_t;

    state_t current_state, next_state;
    logic old_button;
    logic button_trigger;
    logic button_sync;
    logic set_sig;
    logic [7:0] stime_reg;

    // Create a flip-flop to detect the change in the button signal
    always_ff @(posedge i_clk, posedge i_rst) begin
        if (i_rst) begin
            old_button <= 1'b0;
        end else begin
            old_button <= i_button;
            button_trigger <= i_button & ~old_button; // Rising edge detection
        end
    end


    // State register
    always_ff @(posedge i_clk, posedge i_rst) begin
        if (i_rst) begin
            current_state <= S_RED;
        end else if (i_expired) begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state;

        if (i_button) begin
            button_sync = 1'b1;
        end

        case (current_state)
            S_WALK: begin
                if (i_expired) begin
                    next_state = S_RED;
                    stime_reg = 8'd120;
                    set_sig = 1'b1;
                end
            end
            S_RED: begin
                if (i_expired) begin    
                    if (button_trigger) begin
                        next_state = S_WALK;
                        button_sync = 1'b0;
                        stime_reg = 8'd30;
                        set_sig = 1'b1;
                    end else begin
                        next_state = S_GREEN;
                        stime_reg = 8'd120;
                        set_sig = 1'b1;
                    end
                end
            end
            S_GREEN: begin
                if (i_expired) begin
                    next_state = S_YELLOW;
                    stime_reg = 8'd5;
                    set_sig = 1'b1;
                end
            end
            S_YELLOW: begin
                if (i_expired) begin
                    next_state = S_RED;
                    stime_reg = 8'd30;
                    set_sig = 1'b1;
                end
            end
            default: begin
                    next_state = S_RED;
                    stime_reg = 8'd30;
                    set_sig = 1'b1;
                end
        endcase
    end

    // Output logic
    always_comb begin
        case (current_state)
            S_WALK: begin
                o_stop = 1'b0;
                o_walk = 1'b1;
                o_red = 1'b1;
                o_yellow = 1'b0;
                o_green = 1'b0;
            end
            S_RED: begin
                o_stop = 1'b1;
                o_walk = 1'b0;
                o_red = 1'b1;
                o_yellow = 1'b0;
                o_green = 1'b0;
            end
            S_YELLOW: begin
                o_stop = 1'b0;
                o_walk = 1'b0;
                o_red = 1'b0;
                o_yellow = 1'b1;
                o_green = 1'b0;
            end
            S_GREEN: begin
                o_stop = 1'b0;
                o_walk = 1'b0;
                o_red = 1'b0;
                o_yellow = 1'b0;
                o_green = 1'b1;
            end
            default: begin
                o_stop = 1'b1;
                o_walk = 1'b0;
                o_red = 1'b1;
                o_yellow = 1'b0;
                o_green = 1'b0;
            end
        endcase
    end

    always_ff @(posedge i_clk, posedge i_rst) begin
        if (i_rst) begin
            o_stime <= 8'd0;
            o_set <= 1'b0;
        end else if (set_sig) begin
            o_stime <= stime_reg;
            o_set <= set_sig;
            set_sig <= 1'b0;
        end else begin
            o_set <= 1'b0;
        end
    end
endmodule
