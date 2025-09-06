/**
 * @file cordic_data.sv
 * @author Geeoon Chung
 * @brief implements the cordic_data module, the datapath for the cordic module
 */

module cordic_data
    #(parameter BIT_WIDTH,
      parameter LOG_2_BIT_WIDTH,
      parameter END_INDEX,
      parameter K)
    (clk, add, sub, iter, load_regs, target, x, y, reached_target, dir);
    /**
     * @brief controlpath for the cordic module
     * @see ASMD chart
     * @note signals documented in the ASMD chart
     */
    input logic clk, add, sub, iter, load_regs;
    input logic [BIT_WIDTH-1:0] target;

    output logic [BIT_WIDTH-1:0] x, y;
    output logic reached_target, dir; 

    // internal register with an extra bit due to signedness
    logic signed [BIT_WIDTH:0] x_reg, y_reg, shifted_x, shifted_y;

    logic signed [BIT_WIDTH+1:0] current;  // signed and resistant to overflow
    logic [BIT_WIDTH-1:0] target_reg;
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
            target_reg <= target;
            x_reg <= K;
            y_reg <= 0;
            i <= 0;
        end
    end  // always_ff

    always_comb begin
        reached_target = i == END_INDEX;
        dir = current < $signed({2'b00, target_reg});
        if (x_reg[BIT_WIDTH]) begin
            // if its negative
            // convert to magnitude
            x = -x_reg[BIT_WIDTH-1:0];
            shifted_x = x_reg >>> i;
        end else begin
            // if its positive
            x = x_reg[BIT_WIDTH-1:0];
            shifted_x = x_reg >> i;
        end

        if (y_reg[BIT_WIDTH]) begin
            // if its negative
            // convert to magnitude
            y = -y_reg[BIT_WIDTH-1:0];
            shifted_y = y_reg >>> i;
        end else begin
            // if its positive
            y = y_reg[BIT_WIDTH-1:0];
            shifted_y = y_reg >> i;
        end 
    end  // always_comb

endmodule  // cordic_data
