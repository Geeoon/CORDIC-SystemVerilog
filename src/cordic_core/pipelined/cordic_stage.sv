/**
 * @file cordic.sv
 * @author Geeoon Chung
 * @brief implements the cordic_stage module
 * @see https://en.wikipedia.org/wiki/CORDIC
 */

module cordic_stage
    #(parameter BIT_WIDTH, 
      parameter STEP,
      parameter SHIFT_NUM)
    (clk, reset, start, in_target_angle, in_current_angle, in_x, in_y, in_done, out_target_angle, out_current_angle, out_x, out_y, out_done);
    /**
     * @brief a single stage of the CORDIC pipeline
     * @param   BIT_WIDTH the width of the output data.
     *          Trigonometric output of 0 = 0
     *          Trigonometric output of 1 = 2^BIT_WIDTH - 1
     *		AND
     *          the width of the angle (scaled to the first quadrant).
     *          0 radians = 0
     *          pi / 4 radians = 2^(BIT_WIDTH-1)
     *          pi / 2 radians - 0 = 2^BIT_WIDTH - 1
     *          where "- 0" signifies a small value
     * @param   STEP the amount to step by, i.e. tan
     * @param   SHIFT_NUM the number of bits to shift as part of the CORDIC stage
     * @note    do not manually set the BIT_WIDTH
     * @input   clk the clock driving the sequential logic
     * @input   reset an active high reset signal
     * @input	start active high to shift in new values
     * @input   in_target_angle the target angle
     * @input   in_current_angle the angle from the last stage
     * @input   in_x the x coordinate input from the last stage
     * @input   in_y the y coordinate input from the last stage
     * @input   in_done whether or not the last stage's output was the result of a real calculation
     * @output  out_target_angle the target angle
     * @output  out_current_angle the output angle from this stage
     * @output  out_x the x coordinate output
     * @output  out_y the y coordinate output
     * @output  out_done whether or not the output is the result of a real calculation
     */
    input logic clk, reset, start;
    input logic [BIT_WIDTH-1:0] in_target_angle;
    input logic signed [BIT_WIDTH+1:0] in_current_angle;
    input logic signed [BIT_WIDTH:0] in_x, in_y;
    input logic in_done;

    output logic [BIT_WIDTH-1:0] out_target_angle;
    output logic [BIT_WIDTH+1:0] out_current_angle;
    output logic signed [BIT_WIDTH:0] out_x, out_y;
    output logic out_done;

    logic signed [BIT_WIDTH:0] shifted_x, shifted_y;
    logic add;

    assign add = in_current_angle < $signed({2'b00, in_target_angle});

    always_ff @(posedge clk) begin
        if (reset) begin
            out_target_angle <= 0;
            out_current_angle <= 0;
            out_x <= 0;
            out_y <= 0;
            out_done <= 0;
        end else if (start & (in_done | out_done)) begin  // in_done | ~out_done is not required, it's only here to save power
            out_target_angle <= in_target_angle;
            out_done <= in_done;
            if (add) begin
                out_current_angle <= in_current_angle + {2'b00, STEP};
                out_x <= in_x - shifted_y;
                out_y <= in_y + shifted_x;
            end else begin
                out_current_angle <= in_current_angle - {2'b00, STEP};
                out_x <= in_x + shifted_y;
                out_y <= in_y - shifted_x;
            end
        end
    end  // always_ff

    always_comb begin
        shifted_x = in_x >>> SHIFT_NUM;
        shifted_y = in_y >>> SHIFT_NUM;
    end  // always_comb

endmodule
