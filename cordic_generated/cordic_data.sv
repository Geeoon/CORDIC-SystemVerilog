/**
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
                if (start): begin
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
                    else sub = 1
                    ns = s_compute;
                end
            end  // s_compute
        endcase
    end  // always_comb

endmodule  // cordic_ctrl
