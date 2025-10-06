/**
 * @file cordic.sv
 * @author Geeoon Chung
 * @see https://en.wikipedia.org/wiki/CORDIC
 * @brief   computes the coordinates of a rotation using CORDIC with support for pipelining.  Only positive outputs (quadrant I)
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

module cordic #(
    parameter BIT_WIDTH=32,
    parameter ITERATIONS=10
) (
    input   logic                           clk,
    input   logic                           reset,
    input   logic                           start,
    input   logic                           mode,
    input   logic signed [BIT_WIDTH-1:0]    in_angle,
    input   logic signed [BIT_WIDTH-1:0]    in_x,
    input   logic signed [BIT_WIDTH-1:0]    in_y,
    output  logic signed [BIT_WIDTH-1:0]    out_angle,
    output  logic signed [BIT_WIDTH-1:0]    out_x,
    output  logic signed [BIT_WIDTH-1:0]    out_y,
    output  logic                           ready,
    output  logic                           done
);
    // localparams
    localparam real PI = 3.14159265359;

    // signals
    logic pause;
    logic signed [BIT_WIDTH-1:0] target_angles [0:ITERATIONS];
    logic signed [BIT_WIDTH:0] current_angles [0:ITERATIONS];
    logic signed [BIT_WIDTH-1:0] out_xs [0:ITERATIONS];
    logic signed [BIT_WIDTH-1:0] out_ys [0:ITERATIONS];
    logic modes [0:ITERATIONS];
    logic dones [0:ITERATIONS];
    logic signed [BIT_WIDTH:0] last_current_angle;

    // wires
    assign target_angles[0] = in_angle;
    assign current_angles[0] = 0;
    assign out_xs[0] = in_x;
    assign out_ys[0] = in_y;
    assign modes[0] = mode;
    assign dones[0] = start;
    assign pause = ~(start & dones[ITERATIONS]);
    assign done = dones[ITERATIONS];
    assign out_x = out_xs[ITERATIONS];
    assign out_y = out_ys[ITERATIONS];
    assign last_current_angle = current_angles[ITERATIONS];

    genvar i;
    generate
        for (i = 0; i < ITERATIONS; i++) begin
            cordic_stage #(
                .BIT_WIDTH(BIT_WIDTH),
                .STEP($rtoi(0.5 + ($atan2(1.0, 2.0**i) * 2.0**BIT_WIDTH / PI))),
                .SHIFT_NUM(i)
            ) cordic_stage_i (
                .clk,
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
                .out_done(dones[i+1])
            );
        end
    endgenerate

    always_comb begin
        ready = 1;  // pipelined
        // default behavior, remove MSB
        out_angle = $signed({{last_current_angle[BIT_WIDTH], last_current_angle[BIT_WIDTH-2:0]}});
        // this part below will clip values outside of the output range
        if (last_current_angle[BIT_WIDTH]) begin
            // if it's negative and the MSB is set to 0 (meaning it is at least too negative)
            if (~last_current_angle[BIT_WIDTH-1]) out_angle = $signed({{1'b1, {{BIT_WIDTH-1{{1'b0}}}}}});
        end else begin
            // if it's positive and the MSB is set to 1 (meaning it is at least too large)
            if (last_current_angle[BIT_WIDTH-1]) out_angle = $signed({{1'b0, {{BIT_WIDTH-1{{1'b1}}}}}});
        end
    end  // always_comb
endmodule  // cordic
