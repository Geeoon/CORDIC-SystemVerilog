/**
 * @file cordic_rot.sv
 * @author Geeoon Chung
 * @brief implements the cordic_rot module
 * @see https://en.wikipedia.org/wiki/CORDIC
 */

module cordic_rot
    #(parameter DATA_WIDTH = 8,
      parameter ANGLE_WIDTH = 8,
      parameter PHASE_Y = 0)
    (clk, start, angle, out_x, out_y, done);
    /**
     * @brief computes the coordinates of a rotation using CORDIC.  Only positive outputs (quadrant I)
     * @param   DATA_WIDTH=8 the width of the output data.
     *          Trigonometric output of 0 = 0
     *          Trigonometric output of 1 = 
     * @param   ANGLE_WIDTH=8 the width of the angle (scaled to the first quadrant).
     *          0 radians = 0
     *          pi / 4 radians = 2^(ANGLE_WIDTH-1)
     *          pi radians - 0 = 2^ANGLE_WIDTH - 1
     *          where "- 0" signifies a very small value
     * @param   PHASE_Y=0 compute out_y as a pi/2 phase shift
     * @input   clk the clock driving the sequential logic
     * @input   start 1 to start the calculation
     * @note    start will not do anything if done is 0
     * @input   angle the input angle.  width = DATA_WIDTH
     * @output  out_x the x coordinate output.  width = ANGLE_WIDTH
     * @output  out_y the y coordinate output.  width = ANGLE_WIDTH
     * @output  done 1 if the out_x and out_y registers can be read
     */
    input logic [DATA_WIDTH-1:0] angle;
    output logic [OUTPUT_WIDTH-1:0] out_x, out_y;
    
endmodule  // cordic_rot
