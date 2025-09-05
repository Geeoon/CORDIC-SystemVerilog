/**
 * @file cordic_testbench.sv
 * @author Geeoon Chung
 * @brief tests the cordic module
 * @note uses a bit width of 32
 */
module cordic_tb();
    parameter CLOCK_PERIOD = 100;
    // inputs
    logic clk, reset, start;
    logic [31:0] angle;

    // outputs
    logic done;
    logic [31:0] out_x, out_y;

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
        angle = 0;
        @(posedge clk);
        reset = 0;
        @(posedge clk);
        
        // testing angle = 0
        angle = 0;
        start = 1;
        @(posedge done);
        start = 0;
        repeat(2) @(posedge clk);

        // testing angle pi / 4
        angle = 2**31;  // halfway
        start = 1;
        @(posedge done);
        start = 0;
        repeat(2) @(posedge clk);

        // testing angle pi / 6
        angle = 32'd715827883;  // 1/3 the way
        start = 1;
        @(posedge done);
        start = 0;
        repeat(2) @(posedge clk);

        // testing angle pi / 3
        angle = 32'd1431655766;  // 2/3 the way
        start = 1;
        @(posedge done);
        start = 0;
        repeat(2) @(posedge clk);
        $stop;
    end  // initial
    
endmodule  // cordic_tb
