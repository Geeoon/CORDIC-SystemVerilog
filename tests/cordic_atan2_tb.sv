/**
 * @file cordic_atan2_tb.sv
 * @author Geeoon Chung
 * @brief tests the cordic_atan2 module
 * @note uses a bit width of 32
 */
module cordic_atan2_tb();
    parameter CLOCK_PERIOD = 100;
    // inputs
    logic clk, reset, start;
    logic signed [31:0] x, y;

    // outputs
    logic ready, done;
    logic signed [31:0] angle;

    cordic_atan2 dut (.*);

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
        @(posedge clk);
        reset = 0;
        @(posedge clk);
        
        // x = 0, y = 2^30
        x = 0;
        y = {3'b001, 29'b0};
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", x, y);
        $display("\t%d", angle);
        $display("(should be around 1073741823)");
        @(negedge done);

        // x = 2^30, y = 2^30
        x = {3'b001, 29'b0};
        y = {3'b001, 29'b0};
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", x, y);
        $display("\t%d", angle);
        $display("(should be around 536870914)");
        @(negedge done);

        // x = 2^30, y = 0
        x = {3'b001, 29'b0};
        y = {32'b0};
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", x, y);
        $display("\t%d", angle);
        $display("(should be around 0)");
        @(negedge done);

        // x = 2^30, y = -2^30
        x = {3'b001, 29'b0};
        y = {3'b111, 29'b0};
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", x, y);
        $display("\t%d", angle);
        $display("(should be around -536870914)");
        @(negedge done);

        // x = 0, y = -2^30
        x = 0;
        y = {3'b111, 29'b0};
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", x, y);
        $display("\t%d", angle);
        $display("(should be around -1073741823)");
        @(negedge done);

        // x = -2^30, y = -2^30
        x = {3'b111, 29'b0};
        y = {3'b111, 29'b0};
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", x, y);
        $display("\t%d", angle);
        $display("(should be around -1610612737)");
        @(negedge done);

        // x = -2^30, y = 0
        x = {3'b111, 29'b0};
        y = 0;
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", x, y);
        $display("\t%d", angle);
        $display("(should be around -2147483648 or 2147483648)");
        @(negedge done);

        // x = -2^30, y = 2^30
        x = {3'b111, 29'b0};
        y = {3'b001, 29'b0};
        start = 1;
        @(posedge done);
        #1;
        start = 0;
        $display("Results for (%d, %d):", x, y);
        $display("\t%d", angle);
        $display("(should be around -1610612737)");
        @(negedge done);

        repeat(2) @(posedge clk);
        $stop;
    end  // initial
    
endmodule  // cordic_atan2_tb
