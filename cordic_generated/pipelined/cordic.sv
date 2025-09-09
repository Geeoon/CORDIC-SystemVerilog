/**
 * @file cordic.sv
 * @author Geeoon Chung
 * @brief implements the cordic module
 * @see https://en.wikipedia.org/wiki/CORDIC
 */

module cordic
    #(parameter BIT_WIDTH=32, 
      parameter LOG_2_BIT_WIDTH=5,
      parameter K=32'sd1304052707)
    (clk, reset, start, angle, in_x, in_y, out_x, out_y, ready, done);
    /**
     * @brief computes the coordinates of a rotation using CORDIC.  Only positive outputs (quadrant I)
     * @param   BIT_WIDTH the width of the output data.
     *          Trigonometric output of 0 = 0
     *          Trigonometric output of 1 = 2^BIT_WIDTH - 1
     *		AND
     *          the width of the angle (scaled to the first quadrant).
     *          0 radians = 0
     *          pi / 4 radians = 2^(BIT_WIDTH-1)
     *          pi / 2 radians - 0 = 2^BIT_WIDTH - 1
     *          where "- 0" signifies a small value
     * @note    do not set the BIT_WIDTH to be greater than the default.  doing so will likely cause errors
     * @note    update the the rest of the parameters when you update any of them
     * @note    updating the parameters will result in lower effiency.  it is better to regenerate the files 
     * @input   clk the clock driving the sequential logic
     * @input   reset an active high synchronous reset
     * @input	start 1 to start the calculation
     * @note    start will not do anything if done is 0
     * @input   angle the input angle.  width = DATA_WIDTH
     * @input   in_x the input x coordinate, set to K for sine/cosine
     * @input   in_y the input y coordinate of the vector to rotate.  set to 0 for sine/cosine
     * @output  out_x the x coordinate output.  width = BIT_WIDTH
     * @output  out_y the y coordinate output.  width = BIT_WIDTH
     * @output  ready 1 if the module is ready. at this point, start will cause a computation to begin
     * @output  done 1 if the out_x and out_y registers can be read
     */
	input logic clk, reset, start;
	input logic [BIT_WIDTH-1:0] angle, in_x, in_y;

    output logic [BIT_WIDTH-1:0] out_x, out_y;
	output logic ready, done;

    logic reached_target, dir, iter, load_regs, add, sub;
	cordic_ctrl #(.BIT_WIDTH(BIT_WIDTH)) controller (.clk, .reset, .start, .reached_target, .dir, .iter, .load_regs, .add, .sub, .ready, .done);
	cordic_data #(.BIT_WIDTH(BIT_WIDTH), .LOG_2_BIT_WIDTH(LOG_2_BIT_WIDTH), .K(K)) datapath (.clk, .add, .sub, .iter, .load_regs, .target(angle), .in_x, .in_y, .x(out_x), .y(out_y), .reached_target, .dir);
endmodule  // cordic
/**
 * @file cordic_vec.sv
 * @author Geeoon Chung
 * @brief implements the cordic_vec module
 * @see https://en.wikipedia.org/wiki/CORDIC
 */

module cordic_vec
    #(parameter BIT_WIDTH=32, 
      parameter LOG_2_BIT_WIDTH=5)
    (clk, reset, start, in_x, in_y, phase, magnitude, ready, done);
    /**
     * @brief computes the magnitude (with gain) and phase of a vector.  Only positive outputs (quadrant I)
     * @note the algorithm introduces a 1304052707 gain to the output
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
