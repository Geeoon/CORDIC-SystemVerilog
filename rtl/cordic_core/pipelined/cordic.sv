/**
 * @file cordic.sv
 * @author Geeoon Chung
 * @brief implements the cordic module
 * @see https://en.wikipedia.org/wiki/CORDIC
 */

module cordic
    #(parameter BIT_WIDTH={}, 
      parameter LOG_2_BIT_WIDTH={},
      parameter K={})
    (clk, reset, start, in_angle, in_x, in_y, mode, out_angle, out_x, out_y, ready, done);
    /**
     * @brief computes the coordinates of a rotation using CORDIC with support for pipelining.  Only positive outputs (quadrant I)
     * @note    because the CORDIC algorithm applies a gain, do not supply values that are larger than the max_value * K
     * @param   BIT_WIDTH the width of the input and output data.
     * @note    do not set the BIT_WIDTH to be greater than the default.  doing so will likely cause errors
     * @note    update the the rest of the parameters when you update any of them
     * @note    updating the parameters will result in lower effiency.  it is better to regenerate the files 
     * @input   clk the clock driving the sequential logic
     * @input   reset an active high synchronous reset
     * @input	start 1 to start the calculation
     * @input   in_angle the input angle
     * @input   in_x the input x coordinate, set to K for sine/cosine
     * @input   in_y the input y coordinate of the vector to rotate.  set to 0 for sine/cosine
     * @todo    mess with changing to horizontal/vertical for sine/cosine instead of using a phase
     * @input   mode high for vectoring mode, low for rotation mode
     * @output  out_angle the output angle
     * @output  out_x the x coordinate output
     * @output  out_y the y coordinate output
     * @note    the output will be scaled by 1/K
     * @output  ready 1 if the module is ready.  always ready due to pipelining
     * @output  done 1 if the out_x and out_y registers can be read
     */
	input logic clk, reset, start, mode;
	input logic signed [BIT_WIDTH-1:0] in_angle, in_x, in_y;

    output logic signed [BIT_WIDTH-1:0] out_angle, out_x, out_y;
	output logic ready, done;

    assign ready = 1;  // pipelined

    logic pause;

    // table of steps
    localparam int STEPS [BIT_WIDTH] = {};

    logic signed [BIT_WIDTH-1:0] target_angles [0:BIT_WIDTH];
    logic signed [BIT_WIDTH:0] current_angles [0:BIT_WIDTH];
    logic signed [BIT_WIDTH-1:0] out_xs [0:BIT_WIDTH];
    logic signed [BIT_WIDTH-1:0] out_ys [0:BIT_WIDTH];
    logic modes [0:BIT_WIDTH];
    logic dones [0:BIT_WIDTH];

    assign target_angles[0] = in_angle;
    assign current_angles[0] = 0;
    assign out_xs[0] = in_x;
    assign out_ys[0] = in_y;
    assign modes[0] = mode;
    assign dones[0] = start;
    assign pause = ~(start & dones[BIT_WIDTH]);
    assign done = dones[BIT_WIDTH];

    genvar i;
    generate
        for (i = 0; i < BIT_WIDTH; i++) begin
            cordic_stage #(.BIT_WIDTH(BIT_WIDTH), .STEP(STEPS[i]), .SHIFT_NUM(i))
            cordic_stage_i (.clk,
                            .start(pause),
                            .reset,
                            .in_target_angle(target_angles[i]),
                            .in_current_angle(current_angles[i]),
                            .in_x(out_xs[i]),
                            .in_y(out_ys[i]),
                            .in_mode(modes[i]),
                            .in_done(dones[i]),
                            .out_target_angle(target_angles[i+1]),  // we could disconnect the last one as an optimization
                            .out_current_angle(current_angles[i+1]),
                            .out_x(out_xs[i+1]),
                            .out_y(out_ys[i+1]),
                            .out_mode(modes[i+1]),
                            .out_done(dones[i+1]));
        end
    endgenerate

    assign out_x = out_xs[BIT_WIDTH];
    assign out_y = out_ys[BIT_WIDTH];
endmodule  // cordic
