`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FH Joanneum
// Engineer: Umer Farooq
// 
// Create Date: 10/31/2025 12:35:33 AM
// Design Name: 
// Module Name: conf_pulse_generator
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


module conf_pulse_generator(input logic [11:0] i_lowtime,
                            input logic [11:0] i_hightime,
                            input logic [5:0] i_cycles,     // number of cycles to generate pulse for
                            input i_trigger,    // triggers the pulse generation
                            input i_override,   // when high, forces infinite pulse generation regardless of cycles
                            input i_clk,
                            input i_rst,
                            output logic o_pulse
    );

    typedef enum logic [1:0] {
        IDLE,
        HIGH,
        LOW
    } state_t;

    state_t current_state, next_state;
    logic [11:0] counter;
    logic [12:0] time_count;
    logic [11:0] cycles_count;
    
    // State Transition
    always_ff @(posedge i_clk, posedge i_rst) begin
        if (i_rst) begin
            current_state <= IDLE;
            counter <= 12'd0;
            cycles_count <= 12'd0;
        end else begin
            current_state <= next_state;
            if (current_state == HIGH || current_state == LOW) begin
                counter <= time_count;
            end else begin
                counter <= 12'd0;
            end
        end
    end

    // Next State Logic
    always_comb begin
        next_state = current_state;
        time_count = counter;
        case (current_state)
            IDLE: begin
                if (i_trigger && (i_override || cycles_count < i_cycles)) begin
                    next_state = HIGH;
                end
            end
            HIGH: begin
                if (counter >= i_hightime) begin
                    next_state = LOW;
                    time_count = 12'd0;
                end else begin
                    time_count = time_count + 12'd1;
                end
            end
            LOW: begin
                if (counter >= i_lowtime) begin
                    if (i_override || (cycles_count + 12'd1 < i_cycles)) begin
                        next_state = HIGH;
                        cycles_count = cycles_count + 12'd1;
                        time_count = 12'd0;
                    end else begin
                        next_state = IDLE;
                    end
                end else begin
                    time_count = time_count + 12'd1;
                end
            end
        endcase
    end

    // Output Logic
    always_comb begin
        o_pulse = 1'b0;
        case (current_state)
            HIGH: o_pulse = 1'b1;
            default: o_pulse = 1'b0;
        endcase
    end
endmodule
