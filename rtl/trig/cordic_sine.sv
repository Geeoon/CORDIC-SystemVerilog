/**
 * @file cordic_sine.sv
 * @author Geeoon Chung
 * @brief computes the sine of an angle using CORDIC
 * @param   BIT_WIDTH the width of the input and the output
 * @param   LOG_2_BIT log base 2 of the bit width
 * @param   K the precomputed K constant
 * @note    do not set the BIT_WIDTH to be greater than the default.  doing so will likely cause errors
 * @note    update the the rest of the parameters when you update any of them
 * @note    updating the parameters will result in lower effiency.  it is better to regenerate the files 
 * @input   reset a synchronous active high reset
 * @input   angle the input to the sine function.  Ranges from pi / 2 to -pi / 2.
 * @input   start active high start to the calculation
 * @output  value the output of the sine function
 * @output  ready whether or not the module is ready to start a computation
 * @output  done whether or not the computation is complete
 */

import cordic_helper::*;

module cordic_sine #(
    parameter BIT_WIDTH=32, 
    parameter ITERATIONS=10
) (
    input   logic                           clk,
    input   logic                           reset,
    input   logic                           start,
    input   logic signed [BIT_WIDTH-1:0]    angle,
    output  logic signed [BIT_WIDTH-1:0]    value,
    output  logic                           ready,
    output  logic                           done
);
    // localparams
    localparam int K = calculate_K(BIT_WIDTH, ITERATIONS);

    // signals
    logic signed [BIT_WIDTH-1:0] cordic_out;
    logic cordic_ready, cordic_done;

    // submodules
    cordic #(
        .BIT_WIDTH(BIT_WIDTH),
        .ITERATIONS(ITERATIONS)
    ) cordic_module (
        .clk,
        .reset,
        .start,
        .in_angle(angle),
        .in_x(K),
        .in_y(0),
        .mode(1'b0),
        .out_angle(),  // unused
        .out_x(),  // unused
        .out_y(cordic_out),
        .ready(cordic_ready),
        .done(cordic_done)
    );

    always_ff @(posedge clk) begin
        if (reset) begin
            value <= 0;
            done <= 0;
            ready <= 0;
        end else begin
            // register the output to prevent timing issues
            value <= cordic_out;
            // register "ready" as part of cutset
            ready <= cordic_ready;
            // register "done" as part of cutset
            done <= cordic_done;
        end
    end  // always_ff
endmodule  // cordic_sine
