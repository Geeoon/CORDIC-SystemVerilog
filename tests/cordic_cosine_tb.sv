/**
 * @file cordic_cosine_tb.sv
 * @author Geeoon Chung
 * @brief tests the cordic_cosine module
 * @note uses a bit width of 32
 */
module cordic_cosine_tb();
    parameter CLOCK_PERIOD = 100;
    // inputs
    logic clk, reset, start;
    logic signed [31:0] angle;

    // outputs
    logic ready, done;
    logic signed [31:0] value;

    cordic_cosine dut (.*);

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
        
        $stop;
    end  // initial
    
endmodule  // cordic_cosine_tb
