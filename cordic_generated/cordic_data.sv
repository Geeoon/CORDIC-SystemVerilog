/**
 * @file cordic_data.sv
 * @author Geeoon Chung
 * @brief implements the cordic_data module, the datapath for the cordic module
 */

module cordic_data
    #(parameter BIT_WIDTH,
      parameter LOG_2_BIT_WIDTH,
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

    // internal register with two extra bits due to pre-scaling and signedness
    logic signed [BIT_WIDTH+1:0] x_reg, y_reg, shifted_x, shifted_y;

    logic [BIT_WIDTH-1:0] target_reg, current;
    logic [BIT_WIDTH-1:0] diff;  // technically if we make this -1 instead of -2, it will allow us to have
    // bit widths of 1, but at that point, you could just write a normal LUT
    logic [LOG_2_BIT_WIDTH-1:0] i;

    always_ff @(posedge clk) begin
        if (add) begin
            current <= current + diff;
            x_reg <= x_reg - shifted_y;
            y_reg <= y_reg + shifted_x;
        end

        if (sub) begin
            current <= current - diff;
            x_reg <= x_reg + shifted_y;
            y_reg <= y_reg - shifted_x;
        end

        if (iter) begin
            i <= i + 1;
            diff <= diff >> 1;
        end

        if (load_regs) begin
            diff <= {1'b1, {(BIT_WIDTH-1){1'b0}}};
            current <= 0;
            target_reg <= target;
            x_reg <= K;
            y_reg <= 0;
            i <= 0;
        end
    end  // always_ff

    always_comb begin
        reached_target = i == {(LOG_2_BIT_WIDTH){1'b1}};
        dir = current < target;
        if (x_reg[BIT_WIDTH+1]) begin
            // if its negative
            // clip off the extra bit then convert to magnitude
            x = ~x_reg[BIT_WIDTH-1:0] + {{(BIT_WIDTH-1){1'b0}}, 1'b1};
            shifted_x = x_reg >>> i;
        end else begin
            // if its positive
            shifted_x = x_reg >> i;
            x = x_reg[BIT_WIDTH-1:0];
        end

        if (y_reg[BIT_WIDTH+1]) begin
            // if its negative
            // clip off the extra bit then convert to magnitude
            y = ~y_reg[BIT_WIDTH-1:0] + {{(BIT_WIDTH-1){1'b0}}, 1'b1};
            shifted_y = y_reg >>> i;
        end else begin
            // if its positive
            y = y_reg[BIT_WIDTH-1:0];
            shifted_y = y_reg >> i;
        end 
    end  // always_comb

endmodule  // cordic_data
