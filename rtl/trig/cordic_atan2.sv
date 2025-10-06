/**
 * @file cordic_atan2.sv
 * @author Geeoon Chung
 * @brief computes the arctangent of an angle using CORDIC
 * @param   BIT_WIDTH the width of the input and the output
 * @param   LOG_2_BIT log base 2 of the bit width
 * @param   K the precomputed K constant
 * @note    do not set the BIT_WIDTH to be greater than the default.  doing so will likely cause errors
 * @note    update the the rest of the parameters when you update any of them
 * @note    updating the parameters will result in lower effiency.  it is better to regenerate the files 
 * @input   clk the clock driving the sequential logic
 * @input   reset a synchronous active high reset
 * @input   start active high start to the calculation
 * @input   x, the x-coordinate
 * @input   y, the y-coordinate
 * @output  angle, arctangent of the point
 * @output  ready whether or not the module is ready to start a computation
 * @output  done whether or not the computation is complete
 */

module cordic_atan2 #(
    parameter BIT_WIDTH=32,
    parameter ITERATIONS=10
) (
    input   logic                           clk,
    input   logic                           reset,
    input   logic                           start,
    input   logic signed [BIT_WIDTH-1:0]    x,
    input   logic signed [BIT_WIDTH-1:0]    y,
    input   logic signed [BIT_WIDTH-1:0]    angle,
    output  logic                           ready,
    output  logic                           done
);
    // signals
    logic signed [BIT_WIDTH-1:0] in_x, in_y;
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
        .in_angle(),  // unused
        .in_x,
        .in_y,
        .mode(1'b1),  // vectoring mode
        .out_angle(cordic_out),
        .out_x(),  // unused
        .out_y(),  // unused
        .ready(cordic_ready),
        .done(cordic_done)
    );

    always_comb begin
        in_x = x;
        in_y = y;
        if (x[BIT_WIDTH-1]) begin
            in_x = ~x;  // force back to positive
        end 
    end  // always_comb

    always_ff @(posedge clk) begin
        if (reset) begin
            angle <= 0;
            done <= 0;
            ready <= 0;
        end else begin
        // we have to divide the CORDIC output by two because the range is
        // now -pi to pi instead of -pi/2 to pi/2
        // conversion from atan to atan2
        if (x[BIT_WIDTH-1]) begin
            // check if x is negative
            if (y[BIT_WIDTH-1]) begin
                // quandrant III
                angle <= ~($signed(cordic_out >>> 1) + {1'b0, {(BIT_WIDTH-1){1'b1}}});
            end else begin
                // quadrant II
                angle <= $signed(cordic_out >>> 1) + {1'b0, {(BIT_WIDTH-1){1'b1}}};
            end
        end else begin
            // quadrants I and IV
            angle <= cordic_out >>> 1;
        end
            // register "ready" as part of cutset
            ready <= cordic_ready;
            // register "done" as part of cutset
            done <= cordic_done;
        end
    end  // always_ff

endmodule  // cordic_atan2
