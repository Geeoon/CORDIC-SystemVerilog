"""
NOTE:
for normal CORDIC:
* may save a clock cycle by starting the calculation at 45 degrees and manually checking if the angle is 0
"""

CORDIC_MODULE = """/**
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

    logic [BIT_WIDTH:0] x_reg, y_reg;  // internal register with an extra bit due to pre-scaling

    logic [BIT_WIDTH-1:0] target_reg, current;
    logic [BIT_WIDTH-1:0] diff;  // technically if we make this -1 instead of -2, it will allow us to have
    // bit widths of 1, but at that point, you could just write a normal LUT
    logic [LOG_2_BIT_WIDTH:0] i;  // we need an extra bit to bitshift to the end; TODO: rename

    assign x = x_reg[BIT_WIDTH-1:0]
    assign y = y_reg[BIT_WIDTH-1:0]

    always_ff @(posedge clk) begin
        if (add) begin
            current <= current + diff;
            x_reg <= x_reg - (y_reg >> i);
            y_reg <= y_reg - (x_reg >> i);
        end

        if (sub) begin
            current <= current - diff;
            x_reg <= x_reg + (y_reg >> i);
            y_reg <= y_reg - (x_reg >> i);
        end

        if (iter) begin
            i <= i + 1;
            diff <= diff >> 1;
        end

        if (load_regs) begin
            diff <= {1'b1, {(BIT_WIDTH-1){1'b0}}};  // NOTE: might give truncation warning
            current <= 0;
            target_reg <= target;
            x_reg <= K;
            y_reg <= 0;
            i <= 1;
        end
    end  // always_ff

    always_comb begin
        reached_target = current == target;
        dir = current < target;
    end  // always_comb

endmodule  // cordic_data
"""

CORDIC_CTRL_MODULE = """/**
 * @file cordic_ctrl.sv
 * @author Geeoon Chung
 * @brief implements the cordic_ctrl module, the controlpath for the cordic module
 */

module cordic_ctrl
    #(parameter BIT_WIDTH)
    (clk, reset, start, reached_target, dir, iter, load_regs, add, sub, done);
    /**
     * @brief datapath for the cordic module
     * @see ASMD chart
     * @note signals documented in the ASMD chart
     */
    input logic clk, reset, start, reached_target, dir;

    output logic iter, load_regs, add, sub, done;

    enum logic { s_init, s_compute } ps, ns;

    always_ff @(posedge clk) begin
        if (reset) ps <= s_init;
        else ps <= ns;
    end  // always_ff

    always_comb begin
        iter = 0;
        load_regs = 0;
        add = 0;
        sub = 0;
        done = 0;
        case (ps)
            s_init: begin
                done = 1;
                if (start) begin
                    load_regs = 1;
                    ns = s_compute;
                end else begin
                    ns = s_init;
                end
            end  // s_init

            s_compute: begin
                if (reached_target) begin
                    done = 1;  // saves a clock cycle
                    ns = s_init;
                end else begin
                    iter = 1;
                    if (dir) add = 1;
                    else sub = 1;
                    ns = s_compute;
                end
            end  // s_compute
        endcase
    end  // always_comb

endmodule  // cordic_ctrl
"""

CORDIC_DATA_MODULE = """/**
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

    logic [BIT_WIDTH:0] x_reg, y_reg;  // internal register with an extra bit due to pre-scaling

    logic [BIT_WIDTH-1:0] target_reg, current;
    logic [BIT_WIDTH-1:0] diff;  // technically if we make this -1 instead of -2, it will allow us to have
    // bit widths of 1, but at that point, you could just write a normal LUT
    logic [LOG_2_BIT_WIDTH:0] i;  // we need an extra bit to bitshift to the end; TODO: rename

    assign x = x_reg[BIT_WIDTH-1:0]
    assign y = y_reg[BIT_WIDTH-1:0]

    always_ff @(posedge clk) begin
        if (add) begin
            current <= current + diff;
            x_reg <= x_reg - (y_reg >> i);
            y_reg <= y_reg - (x_reg >> i);
        end

        if (sub) begin
            current <= current - diff;
            x_reg <= x_reg + (y_reg >> i);
            y_reg <= y_reg - (x_reg >> i);
        end

        if (iter) begin
            i <= i + 1;
            diff <= diff >> 1;
        end

        if (load_regs) begin
            diff <= {1'b1, {(BIT_WIDTH-1){1'b0}}};  // NOTE: might give truncation warning
            current <= 0;
            target_reg <= target;
            x_reg <= K;
            y_reg <= 0;
            i <= 1;
        end
    end  // always_ff

    always_comb begin
        reached_target = current == target;
        dir = current < target;
    end  // always_comb

endmodule  // cordic_data
"""