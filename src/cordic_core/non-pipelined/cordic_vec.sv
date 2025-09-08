/**
 * @file cordic_vec.sv
 * @author Geeoon Chung
 * @brief implements the cordic_vec module
 * @see https://en.wikipedia.org/wiki/CORDIC
 */

module cordic_vec
    #(parameter BIT_WIDTH={}, 
      parameter LOG_2_BIT_WIDTH={})
    (clk, reset, start, in_x, in_y, phase, magnitude, ready, done);
    /**
     * @brief computes the magnitude (with gain) and phase of a vector.  Only positive outputs (quadrant I)
     * @note the algorithm introduces a {} gain to the output
     * @param   BIT_WIDTH the width of the output phase.
     *          the width of the angle (scaled to the first quadrant).
     *          0 radians = 0
     *          pi / 4 radians = 2^(BIT_WIDTH-1)
     *          pi / 2 radians - 0 = 2^BIT_WIDTH - 1
     *          where "- 0" signifies a small value
     *		AND
     *          the width of the x and y points of the vector.
     * @note    do not set the BIT_WIDTH to be greater than the default.  doing so will likely cause errors
     * @note    update the the rest of the parameters when you update any of them
     * @note    updating the parameters will result in lower effiency.  it is better to regenerate the files 
     * @input   clk the clock driving the sequential logic
     * @input   reset an active high synchronous reset
     * @input	start 1 to start the calculation
     * @note    start will not do anything if done is 0
     * @input   in_x the input x coordinate
     * @input   in_y the input y coordinate
     * @output  phase the phase/angle of the vector
     * @output  magnitude the magnitude of the vector
     * @output  ready 1 if the module is ready. at this point, start will cause a computation to begin
     * @output  done 1 if the out_x and out_y registers can be read
     */
	input logic clk, reset, start;
	input logic [BIT_WIDTH-1:0] in_x, in_y;

    output logic [BIT_WIDTH-1:0] phase, magnitude;
	output logic ready, done;

    logic reached_target, dir, iter, load_regs, add, sub;
	cordic_ctrl #(.BIT_WIDTH(BIT_WIDTH)) controller (.clk, .reset, .start, .reached_target, .dir, .iter, .load_regs, .add, .sub, .ready, .done);
	cordic_vec_data #(.BIT_WIDTH(BIT_WIDTH), .LOG_2_BIT_WIDTH(LOG_2_BIT_WIDTH)) datapath (.clk, .add, .sub, .iter, .load_regs, .in_x, .in_y, .phase, .magnitude, .reached_target, .dir);
endmodule  // cordic_vec
