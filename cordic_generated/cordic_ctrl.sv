/**
 * @file cordic_rot.sv
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

    logic [BIT_WIDTH-1:0] target_reg, current;
    logic [BIT_WIDTH-2:0] diff;
    logic [LOG_2_BIT_WIDTH-1:0] i;

    always_ff @(posedge clk) begin
        if (add) begin
            current <= current + diff;
            x <= x - (y >> i);
            y <= y - (x >> i);
        end

        if (sub) begin
            current <= current - diff;
            x <= x + (y >> i);
            y <= y - (x >> i);
        end

        if (iter) begin
            i <= i + 1;
            diff <= diff >> 1;
        end

        if (load_regs) begin
            diff <= '1;  // NOTE: might give truncation warning
            current <= 0;
            target_reg <= target;
            x <= K;
            y <= 0;
            i <= 1;
        end
    end  // always_ff

    always_comb begin
        reached_target = current == target;
        dir = current < target;
    end  // always_comb

endmodule  // cordic_data
