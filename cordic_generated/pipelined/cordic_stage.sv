/**
 * @file cordic_stage.sv
 * @author Geeoon Chung
 * @brief implements the cordic_stage module
 */

module cordic_stage
    #(parameter BIT_WIDTH, 
      parameter STEP,
      parameter SHIFT_NUM)
    (clk, reset, start, in_target_angle, in_current_angle, in_x, in_y, in_mode, in_done, out_target_angle, out_current_angle, out_x, out_y, out_mode, out_done);
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
     * @input   in_mode whether or not the last stage's output was the reuslt of rotation mode (low) or vectoring mode (high)
     * @input   in_done whether or not the last stage's output was the result of a real calculation
     * @output  out_target_angle the target angle
     * @output  out_current_angle the output angle from this stage
     * @output  out_x the x coordinate output
     * @output  out_y the y coordinate output
     * @output  out_mode whether or not the output is the result of rotation mode (low) or vectoing mode (high)
     * @output  out_done whether or not the output is the result of a real calculation
     */
    input logic clk, reset, start;
    input logic signed [BIT_WIDTH-1:0] in_target_angle;
    input logic signed [BIT_WIDTH:0] in_current_angle;  // extra for overflow protection
    input logic signed [BIT_WIDTH-1:0] in_x, in_y;
    input logic in_mode, in_done;

    output logic signed [BIT_WIDTH-1:0] out_target_angle;
    output logic signed [BIT_WIDTH:0] out_current_angle;  // extra bit for overflow protection
    output logic signed [BIT_WIDTH-1:0] out_x, out_y;  // could extend this one bit and add overflow protection on the main cordic module
    output logic out_mode, out_done;

    logic signed [BIT_WIDTH-1:0] shifted_x, shifted_y;
    logic add;

    always_comb begin
        if (in_mode) add = in_y[BIT_WIDTH-1];
        // extend the MSB to match the bit widths
        else add = in_current_angle < $signed({in_target_angle[BIT_WIDTH-1], in_target_angle});
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            out_target_angle <= 0;
            out_current_angle <= 0;
            out_x <= 0;
            out_y <= 0;
            out_mode <= 0;
            out_done <= 0;
        end else if (start & (in_done | out_done)) begin  // in_done | ~out_done is not required, it's only here to save power
            out_target_angle <= in_target_angle;
            out_mode <= in_mode;
            out_done <= in_done;
            if (add) begin
                if (in_mode) out_current_angle <= in_current_angle - {3'b00, STEP};
                else out_current_angle <= in_current_angle + {3'b00, STEP};
                out_x <= in_x - shifted_y;
                out_y <= in_y + shifted_x;
            end else begin
                if (in_mode) out_current_angle <= in_current_angle + {3'b00, STEP};
                else out_current_angle <= in_current_angle - {3'b00, STEP};
                out_x <= in_x + shifted_y;
                out_y <= in_y - shifted_x;
            end
        end
    end  // always_ff

    assign shifted_x = in_x >>> SHIFT_NUM;
    assign shifted_y = in_y >>> SHIFT_NUM;

endmodule  // cordic_stage
