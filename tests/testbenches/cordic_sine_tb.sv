/**
 * @file cordic_sine_tb.sv
 * @author Geeoon Chung
 * @brief tests the cordic_sine module
 * @note uses a bit width of 32
 */

import cordic_tb_helper::*;

module cordic_sine_tb();
    parameter CLOCK_PERIOD = 100;
    parameter ITERATIONS = 32;

    // inputs
    logic clk, reset, start;
    logic signed [31:0] angle;

    // outputs
    logic ready, done;
    logic signed [31:0] value;

    cordic_sine #(
      .ITERATIONS(ITERATIONS)  
    ) dut (.*);

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
        $display("Results for angle = 0:");
        $display("\t%d", value);
        $display(real'(value) / 2.0**(ITERATIONS-1));
        assert(almost_equal(real'(value) / 2.0**(ITERATIONS-1), $sin(0)));
        @(negedge done);

        // testing angle pi / 4
        angle = 32'sd1073741824;
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = pi / 4:");
        $display("\t%d", value);
        @(negedge done);


        // testing angle -pi / 4
        angle = -32'sd1073741824;
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = -pi / 4:");
        $display("\t%d", value);
        @(negedge done);

        // testing angle pi / 3
        angle = 32'sd1431655770;
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = pi / 3:");
        $display("\t%d", value);
        @(negedge done);

        // testing angle 2pi / 3
        angle = 32'sd2863311540;
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = 2pi / 3:");
        $display("\t%d", value);
        @(negedge done);
        
        // testing almost angle pi / 2
        angle = {1'b0, {31{1'b1}}};
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = pi / 2");
        $display("\t%d", value);
        @(negedge done);

        // testing almost angle -pi / 2
        angle = {1'b1, 31'b0};
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = -pi / 2:");
        $display("\t%d", value);
        @(negedge done);
        repeat(2) @(posedge clk)
        
        $dumpfile("cordic_sine_tb.vcd");
        $dumpvars;
        $finish;
    end  // initial
    
endmodule  // cordic_sine_tb
