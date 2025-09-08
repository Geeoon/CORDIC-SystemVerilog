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
    (clk, reset, start, angle, out_x, out_y, ready, done);
    /**
     * @brief computes the coordinates of a rotation using CORDIC with support for pipelining.  Only positive outputs (quadrant I)
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
     * @input   angle the input angle.  width = DATA_WIDTH
     * @output  out_x the x coordinate output.  width = BIT_WIDTH
     * @output  out_y the y coordinate output.  width = BIT_WIDTH
     * @output  ready 1 if the module is ready.  always ready due to pipelining
     * @output  done 1 if the out_x and out_y registers can be read
     */
	input logic clk, reset, start;
	input logic [BIT_WIDTH-1:0] angle;

    output logic [BIT_WIDTH-1:0] out_x, out_y;
	output logic ready, done;

    assign ready = 1;  // pipelined

    logic pause;

    // table of steps
    localparam int STEPS [BIT_WIDTH] = {};

    logic [BIT_WIDTH-1:0] target_angles [0:BIT_WIDTH];
    logic signed [BIT_WIDTH+1:0] current_angles [0:BIT_WIDTH];
    logic signed [BIT_WIDTH:0] out_xs [0:BIT_WIDTH];
    logic signed [BIT_WIDTH:0] out_ys [0:BIT_WIDTH];
    logic dones [0:BIT_WIDTH];

    assign target_angles[0] = angle;
    assign current_angles[0] = 0;
    assign out_xs[0] = K;
    assign out_ys[0] = 0;
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
                            .in_done(dones[i]),
                            .out_target_angle(target_angles[i+1]),  // we could disconnect the last one as an optimization
                            .out_current_angle(current_angles[i+1]),
                            .out_x(out_xs[i+1]),
                            .out_y(out_ys[i+1]),
                            .out_done(dones[i+1]));
        end
    endgenerate

    always_comb begin
        if (out_xs[BIT_WIDTH][BIT_WIDTH]) begin
            // if its negative
            // convert to magnitude
            out_x = ~out_xs[BIT_WIDTH][BIT_WIDTH-1:0];  // this method is off by one but faster and won't overflow
        end else begin
            // if its positive
            out_x = out_xs[BIT_WIDTH][BIT_WIDTH-1:0];
        end

        if (out_ys[BIT_WIDTH][BIT_WIDTH]) begin
            // if its negative
            // convert to magnitude
            out_y = ~out_ys[BIT_WIDTH][BIT_WIDTH-1:0];  // this method is off by one but faster and won't overflow
        end else begin
            // if its positive
            out_y = out_ys[BIT_WIDTH][BIT_WIDTH-1:0];
        end 
    end  // always_comb
endmodule  // cordic
