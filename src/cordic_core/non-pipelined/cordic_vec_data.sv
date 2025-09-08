/**
 * @file cordic_vec_data.sv
 * @author Geeoon Chung
 * @brief implements the cordic_data module, the datapath for the cordic module
 */

module cordic_vec_data
    #(parameter BIT_WIDTH,
      parameter LOG_2_BIT_WIDTH)
    (clk, add, sub, iter, load_regs, in_x, in_y, phase, magnitude, reached_target, dir);
    /**
     * @brief controlpath for the cordic module
     * @see ASMD chart
     * @note signals documented in the ASMD chart
     */
    input logic clk, add, sub, iter, load_regs;
    input logic [BIT_WIDTH-1:0] in_x, in_y;

    output logic [BIT_WIDTH-1:0] phase, magnitude;
    output logic reached_target, dir; 

    // internal register with an extra bit due to signedness
    logic signed [BIT_WIDTH:0] x_reg, y_reg, shifted_x, shifted_y;

    logic signed [BIT_WIDTH+1:0] current;  // signed and resistant to overflow
    logic [BIT_WIDTH-1:0] diff;
    // bit widths of 1, but at that point, you could just write a normal LUT
    logic [LOG_2_BIT_WIDTH-1:0] i;

    cordic_lut #(.INPUT_WIDTH(LOG_2_BIT_WIDTH), .BIT_WIDTH(BIT_WIDTH)) step_lut (.index(i), .value(diff));

    always_ff @(posedge clk) begin
        if (add) begin
            current <= current + {2'b00, diff};
            x_reg <= x_reg - shifted_y;
            y_reg <= y_reg + shifted_x;
        end

        if (sub) begin
            current <= current - {2'b00, diff};
            x_reg <= x_reg + shifted_y;
            y_reg <= y_reg - shifted_x;
        end

        if (iter) begin
            i <= i + 1;
        end

        if (load_regs) begin
            current <= 0;
            x_reg <= {1'b0, in_x};
            y_reg <= {1'b0, in_y};
            i <= 0;
        end
    end  // always_ff

    always_comb begin
        reached_target = i == (BIT_WIDTH - 1);
        dir = y_reg[BIT_WIDTH];  // if y is negative
        shifted_x = x_reg >>> i;
        shifted_y = y_reg >>> i;
        phase = current;
        magnitude = y_reg;

    end  // always_comb

endmodule  // cordic_vec_data
