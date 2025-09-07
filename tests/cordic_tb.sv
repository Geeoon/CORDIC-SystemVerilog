/**
 * @file cordic_tb.sv
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
    logic ready, done;
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
        $display("Results for angle = 0:");
        $display("\t(%d, %d)", out_x, out_y);
        @(negedge done);

        // testing angle pi / 4
        angle = 2**31;  // halfway
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = pi / 4:");
        $display("\t(%d, %d)", out_x, out_y);
        @(negedge done);


        // testing angle pi / 6
        angle = 32'd1431655770;  // 1/3 the way
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = pi / 6:");
        $display("\t(%d, %d)", out_x, out_y);
        @(negedge done);

        // testing angle pi / 3
        angle = 32'd2863311540;  // 2/3 the way
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = pi / 3:");
        $display("\t(%d, %d)", out_x, out_y);
        @(negedge done);
        
        // testing almost angle pi / 2
        angle = {{31{1'b1}}, 1'b0};
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = pi / 2:");
        $display("\t(%d, %d)", out_x, out_y);
        @(negedge done);
        
        $stop;
    end  // initial
    
endmodule  // cordic_tb
