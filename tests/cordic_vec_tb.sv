/**
 * @file cordic_vec_tb.sv
 * @author Geeoon Chung
 * @brief tests the cordic_vec module
 * @note uses a bit width of 32
 */
module cordic_vec_tb();
    parameter CLOCK_PERIOD = 100;
    // inputs
    logic clk, reset, start;
    logic [31:0] in_x, in_y;

    // outputs
    logic ready, done;
    logic [31:0] phase, magnitude;

    cordic_vec dut (.*);

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
        in_x = 0;
        in_y = 0;
        @(posedge clk);
        reset = 0;
        @(posedge clk);
        
        // testing x = 0, y = 2^31; 90 degrees
        in_x = 0;
        in_y = {1'b0, 1'b1, 30'd0};
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for x = 0, y = 2^31:");
        $display("\t(%d, %d)", phase, magnitude);
        @(negedge done);

        // testing x = 2^31, y = 2^31; 45 degrees
        in_x = {1'b0, 1'b1, 30'd0};
        in_y = {1'b0, 1'b1, 30'd0};
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for x = 2^31, y = 2^31, should be 45 degrees:");
        $display("\t(%d, %d)", phase, magnitude);
        @(negedge done);


        // testing x = 2^31, y = 0;  0 degrees
        in_x = {1'b0, 1'b1, 30'd0};
        in_y = 0;
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for x = 2^31, y = 0, should be 0 degrees:");
        $display("\t(%d, %d)", phase, magnitude);
        @(negedge done);

        // testing x = 3719550790, y = 2^31;  60 degrees
        in_x = 32'd3719550790;
        in_y = {1'b0, 1'b1, 30'd0};
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for x = 3719550790, y = 2^31, should be 60 degres:");
        $display("\t(%d, %d)", phase, magnitude);
        @(negedge done);
        
        // testing x = 2^31, y = 3719550790;  30 degrees 
        $display("calc");
        in_x = {1'b0, 1'b1, 30'd0};
        in_y = 32'd3719550790;
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for x = 2^31, y = 3719550790, should be 30 degrees:");
        $display("\t(%d, %d)", phase, magnitude);
        @(negedge done);
        
        $stop;
    end  // initial
    
endmodule  // cordic_vec_tb
