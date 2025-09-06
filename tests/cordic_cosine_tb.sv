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
    logic [31:0] angle;

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
        repeat(2) @(posedge clk);

        // testing angle pi
        angle = 2**31;  // halfway
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = pi:");
        $display("\t%d", value);
        repeat(2) @(posedge clk);

        // testing angle 2pi / 3
        angle = 32'd1431655770;  // 1/3 the way
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = 2pi / 3:");
        $display("\t%d", value);
        repeat(2) @(posedge clk);

        // testing angle 4pi / 3
        angle = 32'd2863311540;  // 2/3 the way
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = 4pi / 3:");
        $display("\t%d", value);
        repeat(2) @(posedge clk);
        
        // testing almost angle 2pi
        angle = {{31{1'b1}}, 1'b0};
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for angle = 2pi - 0:");
        $display("\t%d", value);
        repeat(2) @(posedge clk);
        
        $stop;
    end  // initial
    
endmodule  // cordic_tb
