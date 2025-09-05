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
        angle = 0;
        @(posedge clk);

        // testing angle = 0
        reset = 0;
        angle = 0;
        start = 1;
        @(posedge done);
        start = 0;
        @(posedge clk);

        // TODO: more tests
        $stop;
    end  // initial
    
endmodule  // cordic_tb
