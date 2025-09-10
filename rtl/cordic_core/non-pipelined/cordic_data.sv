/**
 * @file cordic_data.sv
 * @author Geeoon Chung
 * @brief implements the cordic_data module, the datapath for the cordic module
 */

module cordic_data
    #(parameter BIT_WIDTH,
      parameter LOG_2_BIT_WIDTH,
      parameter K)
    (clk, add, sub, iter, load_regs, in_angle, in_x, in_y, mode, out_angle, out_x, out_y, reached_target, dir);
    /**
     * @brief controlpath for the cordic module
     * @see ASMD chart
     * @note signals documented in the ASMD chart
     */
    input logic clk, add, sub, iter, load_regs, mode;
    input logic signed [BIT_WIDTH-1:0] in_angle, in_x, in_y;

    output logic signed [BIT_WIDTH-1:0] out_angle, out_x, out_y;
    output logic reached_target, dir; 

    logic mode_reg;
    logic signed [BIT_WIDTH-1:0] x_reg, y_reg, shifted_x, shifted_y;

    logic signed [BIT_WIDTH:0] current;  // extra bit for overflow resistance
    logic signed [BIT_WIDTH-1:0] target_reg;
    logic [BIT_WIDTH-1:0] diff;

    logic [LOG_2_BIT_WIDTH-1:0] i;

    cordic_lut #(.INPUT_WIDTH(LOG_2_BIT_WIDTH), .BIT_WIDTH(BIT_WIDTH)) step_lut (.index(i), .value(diff));

    always_ff @(posedge clk) begin
        if (add) begin
            if (mode) current <= current - {1'b0, diff};
            else current <= current + {1'b0, diff};
            x_reg <= x_reg - shifted_y;
            y_reg <= y_reg + shifted_x;
        end

        if (sub) begin
            if (mode) current <= current + {1'b0, diff};
            else current <= current - {1'b0, diff};
            x_reg <= x_reg + shifted_y;
            y_reg <= y_reg - shifted_x;
        end

        if (iter) begin
            i <= i + 1;
        end

        if (load_regs) begin
            current <= 0;
            target_reg <= in_angle;
            x_reg <= in_x;
            y_reg <= in_y;
            i <= 0;
            mode_reg <= mode;
        end
    end  // always_ff

    assign shifted_x = x_reg >>> i;
    assign shifted_y = y_reg >>> i;
    assign reached_target = i == (BIT_WIDTH - 1);
    assign out_x = x_reg;
    assign out_y = y_reg;
    assign out_angle = current;
    always_comb begin
        if (mode) dir = out_y < 32'sd0;
        else dir = current < $signed({target_reg[BIT_WIDTH-1], target_reg});
    end
endmodule  // cordic_data
