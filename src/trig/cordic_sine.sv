/**
 * @file cordic_sine.sv
 * @author Geeoon Chung
 * @brief this file implements the cordic_sine module
 */

module cordic_sine
    #(parameter BIT_WIDTH={}, 
      parameter LOG_2_BIT_WIDTH_MIN_2={},
      parameter K={})
    (clk, reset, start, angle, value, ready, done);
    /**
     * @brief computes the sine of an angle using CORDIC
     * @param   BIT_WIDTH the width of the input and the output
     * @param   LOG_2_BIT_WIDTH_MIN_2 log base 2 of the bit width minus 2; i.e. log_2(BIT_WIDTH - 2)
     * @param   K the precomputed K constant
     * @note    do not set the BIT_WIDTH to be greater than the default.  doing so will likely cause errors
     * @note    update the the rest of the parameters when you update any of them
     * @note    updating the parameters will result in lower effiency.  it is better to regenerate the files 
     * @input   reset a synchronous active high reset
     * @input   angle the input to the sine function
     * @input   start active high start to the calculation
     * @output  value the output of the sine function
     * @output  ready whether or not the module is ready to start a computation
     * @output  done whether or not the computation is complete
     */
    input logic clk, reset, start;
    input logic [BIT_WIDTH-1:0] angle;
    
    output logic signed [BIT_WIDTH-1:0] value;
    output logic ready, done;

    logic signed [BIT_WIDTH-1:0] value_int;
    logic [BIT_WIDTH-3:0] cordic_in, cordic_out;
    logic cordic_ready, cordic_done;

    cordic #(.BIT_WIDTH(BIT_WIDTH-2), .LOG_2_BIT_WIDTH(LOG_2_BIT_WIDTH_MIN_2), .K(K))
            cordic_module
            (.clk,
             .reset,
             .start,
             .angle(cordic_in),
             .out_x(),  // unused
             .out_y(cordic_out),
             .ready(coridc_ready),
             .done(cordic_done));

    always_ff @(posedge clk) begin
        if (reset) begin
            value <= 0;
            done <= 0;
            ready <= 0;
        end else begin
            // register the output to prevent timing issues
            value <= value_int;
            // register "ready" as part of cutset
            ready <= cordic_ready;
            // register "done" as part of cutset
            done <= cordic_done;
        end
    end  // always_ff

    always_comb begin
        if (angle[BIT_WIDTH-1]) begin
            // quadrant III and IV (negative)
            value_int = {{1'b1, -cordic_out, 1'b1}};  // doubled because of f string
        end else begin
            // quadrant I and II (positive)
            value_int = {{1'b0, cordic_out, 1'b0}};  // doubled because of f string
        end

        if (angle[BIT_WIDTH-2]) begin
            // quadrant II and IV (mirrored)
            // we need to subtract the angle from 2^BIT_WIDTH-3
            // this is the same as just doing taking the NOT
            cordic_in = ~angle[BIT_WIDTH-3:0];
        end else begin
            // quadrant I and III (non-mirrored)
            cordic_in = angle[BIT_WIDTH-3:0];
        end
    end  // always_comb
endmodule  // cordic_sine
