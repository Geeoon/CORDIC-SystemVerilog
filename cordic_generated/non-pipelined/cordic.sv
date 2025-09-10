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
    (clk, reset, start, in_angle, in_x, in_y, mode, out_angle, out_x, out_y, ready, done);
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
     * @input   in_angle the input angle
     * @input   in_x the input x coordinate, set to K for sine/cosine
     * @input   in_y the input y coordinate of the vector to rotate.  set to 0 for sine/cosine
     * @input   mode high for vectoring mode, low for rotation mode
     * @output  out_angle the output angle
     * @output  out_x the x coordinate output
     * @output  out_y the y coordinate output
     * @output  ready 1 if the module is ready. at this point, start will cause a computation to begin
     * @output  done 1 if the out_x and out_y registers can be read
     */
	input logic clk, reset, start, mode;
	input logic [BIT_WIDTH-1:0] in_angle, in_x, in_y;

    output logic [BIT_WIDTH-1:0] out_angle, out_x, out_y;
	output logic ready, done;

    logic reached_target, dir, iter, load_regs, add, sub;
	cordic_ctrl #(.BIT_WIDTH(BIT_WIDTH)) controller (.clk, .reset, .start, .reached_target, .dir, .iter, .load_regs, .add, .sub, .ready, .done);
	cordic_data #(.BIT_WIDTH(BIT_WIDTH), .LOG_2_BIT_WIDTH(LOG_2_BIT_WIDTH), .K(K)) datapath (.clk, .add, .sub, .iter, .load_regs, .in_angle, .in_x, .in_y, .mode, .out_angle, .out_x, .out_y, .reached_target, .dir);
endmodule  // cordic
