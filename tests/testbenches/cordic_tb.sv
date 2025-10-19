/**
 * @file cordic_tb.sv
 * @author Geeoon Chung
 * @brief tests the cordic module
 * @note uses a bit width of 32
 */

import cordic_tb_helper::*;

module cordic_tb #(
    parameter CLOCK_PERIOD=100,
    parameter ITERATIONS=32,
    parameter WIDTH=32,
    parameter RAND_TRIALS=1000
) ();
    // inputs
    logic clk, reset, start, mode;
    logic signed [WIDTH-1:0] in_angle, in_x, in_y;

    // outputs
    logic ready, done;
    logic signed [WIDTH-1:0] out_angle, out_x, out_y;

    // helper object
    cordic_tester #(.WIDTH(WIDTH)) helper;

    // DUT
    cordic #(
        .ITERATIONS(ITERATIONS)
    ) dut (
        .clk,
        .reset,
        .start,
        .mode,
        .in_angle,
        .in_x,
        .in_y,
        .ready,
        .done,
        .out_angle,
        .out_x,
        .out_y
    );

    initial begin
        clk <= 0;
        forever begin 
            #(CLOCK_PERIOD/2) clk <= ~clk;
        end  // forever
    end  // initial

    bit test;
    int fails = 0;
    initial begin
        // dump waveforms
        $dumpfile("cordic_tb.vcd");
        $dumpvars;
        
        // reset
        reset = 1;
        start = 0;
        in_angle = 0;
        @(posedge clk);
        reset = 0;
        @(posedge clk);

        // rotation mode
        $display("%t: -- STARTING ROTATION MODE TESTS --", $time);
        mode = 0;
        // TODO: random coordinates
        // x = 2^30, y = 0
        in_x = {3'b001, 29'b0};
        in_y = 0;

        // testing angle = 0
        in_angle = 0;
        start = 1;

        @(posedge done);
        start = 0;
        test = helper.test_rotation(in_x, in_y, in_angle, out_x, out_y);
        assert(test);
        @(negedge done);

        // testing random angles
        fails = 0;
        for (int i = 0; i < RAND_TRIALS; i++) begin
            // randomize angle
            helper.randomize_bits(in_angle);
            // start calculation
            start = 1;
            @(posedge done);
            start = 0;
            // test output
            test = helper.test_rotation(in_x, in_y, in_angle, out_x, out_y);
            assert(test);
            if (~test) begin
                // failed test case
                fails++;
                $display("%t: Failed test", $time);
                $display("\tin_x=%d", in_x);
                $display("\tin_y=%d", in_y);
                $display("\tin_angle=%d", in_angle);
                $display("\tout_x=%d", out_x);
                $display("\tout_y=%d\n", out_y);
            end
            @(negedge done);
        end
        $display("Failed %d of %d tests", fails, RAND_TRIALS);
        $display("%t: -- DONE --\n", $time);

        // vectoring mode
        $display("%t: -- STARTING VECTORING MODE TESTS --", $time);
        mode = 1;

        // testing random coordinates
        fails = 0;
        for (int i = 0; i < RAND_TRIALS; i++) begin
            // randomize coordinate
            helper.randomize_bits(in_x);
            helper.randomize_bits(in_y);
            // if the magnitude is too large, there will be an overflow,
            //  so leave 3 extra bits
            in_x = in_x >> 3;  // make positive with logical shift
            in_y = in_y >>> 3;  // keep sign

            // start calculation
            start = 1;
            @(posedge done);
            start = 0;
            // test output
            test = helper.test_vectoring(in_x, in_y, out_angle, out_x);
            assert(test);
            if (~test) begin
                // failed test case
                fails++;
                $display("%t: Failed test", $time);
                $display("\tin_x=%d", in_x);
                $display("\tin_y=%d", in_y);
                $display("\tout_angle=%d", out_angle);
                $display("\tout_x=%d\n", out_x);
            end
            @(negedge done);
        end
        $display("Failed %d of %d tests", fails, RAND_TRIALS);
        $display("%t: -- DONE --\n", $time);

        $finish;

    end  // initial
endmodule  // cordic_tb
