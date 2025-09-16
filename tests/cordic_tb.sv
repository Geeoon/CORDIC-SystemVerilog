/**
 * @file cordic_tb.sv
 * @author Geeoon Chung
 * @brief tests the cordic module
 * @note uses a bit width of 32
 */
module cordic_tb();
    parameter CLOCK_PERIOD = 100;
    // inputs
    logic clk, reset, start, mode;
    logic signed [31:0] in_angle, in_x, in_y;

    // outputs
    logic ready, done;
    logic signed [31:0] out_angle, out_x, out_y;

    cordic dut (.*);

    initial begin
        clk <= 0;
        forever begin 
            #(CLOCK_PERIOD/2) clk <= ~clk;
        end  // forever
    end  // initial

    initial begin
        // reset
        reset = 1;
        start = 0;
        in_angle = 0;
        @(posedge clk);
        reset = 0;
        @(posedge clk);
        
        // rotation mode
        $display("-- Rotation mode tests --");
        mode = 0;
        // x = 2^30, y = 0
        in_x = {3'b001, 29'b0};
        in_y = 0;
        // testing angle = 0
        in_angle = 0;
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d) and angle = 0:", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_y);
        @(negedge done);

        // testing angle pi / 6
        in_angle = {1'b0, 31'd715827883};  // 1/3 the way
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d) and angle = pi / 6:", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_y);
        @(negedge done);

        // testing angle pi / 4
        in_angle = {1'b0, 31'd1073741824};  // halfway
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d) and angle = pi / 4:", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_y);
        @(negedge done);

        // testing angle pi / 3
        in_angle = {1'b0, 31'd1431655766};  // 2/3 the way
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d) and angle = pi / 3:", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_y);
        @(negedge done);
        
        // testing almost angle pi / 2
        in_angle = {1'b0, {31{1'b1}}};  // ~vertical
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d) and angle = pi / 2:", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_y);
        @(negedge done);

        repeat(10) @(posedge clk);

        // vectoring mode
        $display("\n\n-- Vectoring mode tests --");
        mode = 1;
        // x = 0, y = 2^30
        in_x = 0;
        in_y = {3'b001, 29'b0};
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", in_x, in_y);
        $display("\t%d", out_angle);
        @(negedge done);

        // x = 2^30, y = 2^30
        in_x = {3'b001, 29'b0};
        in_y = {3'b001, 29'b0};
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", in_x, in_y);
        $display("\t%d", out_angle);
        @(negedge done);

        // x = 2^30, y = 0
        in_x = {3'b001, 29'b0};
        in_y = {32'b0};
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", in_x, in_y);
        $display("\t%d", out_angle);
        @(negedge done);

        // x = 2^30, y = -2^30
        in_x = {3'b001, 29'b0};
        in_y = {3'b111, 29'b0};
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", in_x, in_y);
        $display("\t%d", out_angle);
        @(negedge done);

        // x = 0, y = -2^30
        in_x = 0;
        in_y = {3'b111, 29'b0};
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", in_x, in_y);
        $display("\t%d", out_angle);
        @(negedge done);

        repeat(2) @(posedge clk);
        $stop;
    end  // initial
    
endmodule  // cordic_tb
