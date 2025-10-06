/**
 * @file cordic_tb.sv
 * @author Geeoon Chung
 * @brief tests the cordic module
 * @note uses a bit width of 32
 */
module cordic_tb();
    localparam real K = 0.6072529350088812561694;
    localparam real PI = 3.14159265359;
    localparam CLOCK_PERIOD = 100;
    localparam ITERATIONS = 32;

    function bit check_rotation_values(real angle, real magnitude, real x, real y);
        return  almost_equal(magnitude * $cos(angle), x * K) &
                almost_equal(magnitude * $sin(angle), y * K);
    endfunction

    function bit check_vectorizing_values(out_x, out_angle, in_x, in_y);
        return  almost_equal(out_x * K, $sqrt(in_x**2 + real'(in_y)**2)) &
                almost_equal(PI * real'(out_angle) / 2.0**32, $atan2(in_y, in_x), .EPSILON(0.0005));
    endfunction

    function real abs(real value);
        if (value > 0) begin
            return value;
        end else begin
            return -value;
        end
    endfunction

    function bit almost_equal(real value1, real value2, real EPSILON=10000);
        return abs(value1 - value2) <= EPSILON;
    endfunction

    // inputs
    logic clk, reset, start, mode;
    logic signed [31:0] in_angle, in_x, in_y;

    // outputs
    logic ready, done;
    logic signed [31:0] out_angle, out_x, out_y;

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
        assert(check_rotation_values(0, in_x, out_x, out_y));
        @(negedge done);

        // testing angle pi / 6
        in_angle = {1'b0, 31'd715827883};  // 1 / 3 the way
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d) and angle = pi / 6:", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_y);
        assert(check_rotation_values(PI / 6, in_x, out_x, out_y));
        @(negedge done);

        // testing angle pi / 4
        in_angle = {1'b0, 31'd1073741824};  // halfway
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d) and angle = pi / 4:", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_y);
        assert(check_rotation_values(PI / 4, in_x, out_x, out_y));
        @(negedge done);

        // testing angle pi / 3
        in_angle = {1'b0, 31'd1431655766};  // 2/3 the way
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d) and angle = pi / 3:", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_y);
        assert(check_rotation_values(PI / 3, in_x, out_x, out_y));
        @(negedge done);
        
        // testing almost angle pi / 2
        in_angle = {1'b0, {31{1'b1}}};  // ~vertical
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d) and angle = pi / 2:", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_y);
        assert(check_rotation_values(PI / 2, in_x, out_x, out_y));
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
        start = 0;
        $display("Results for (%d, %d):", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_angle);
        assert(check_vectorizing_values(out_x, out_angle, in_x, in_y));
        @(negedge done);

        // x = 2^30, y = 2^30
        in_x = {3'b001, 29'b0};
        in_y = {3'b001, 29'b0};
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d):", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_angle);
        assert(check_vectorizing_values(out_x, out_angle, in_x, in_y));
        @(negedge done);

        // x = 2^30, y = 0
        in_x = {3'b001, 29'b0};
        in_y = {32'b0};
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d):", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_angle);
        assert(check_vectorizing_values(out_x, out_angle, in_x, in_y));
        @(negedge done);

        // x = 2^30, y = -2^30
        in_x = {3'b001, 29'b0};
        in_y = {3'b111, 29'b0};
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d):", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_angle);
        assert(check_vectorizing_values(out_x, out_angle, in_x, in_y));
        @(negedge done);

        // x = 0, y = -2^30
        in_x = 0;
        in_y = {3'b111, 29'b0};
        start = 1;
        @(posedge done);
        start = 0;
        $display("Results for (%d, %d):", in_x, in_y);
        $display("\t(%d, %d)", out_x, out_angle);
        assert(check_vectorizing_values(out_x, out_angle, in_x, in_y));
        @(negedge done);

        repeat(2) @(posedge clk);
        $stop;
    end  // initial

    // unsupported by Verilator and ModelSim
    // sequence s_rotate_ready;
    //     (mode == 0) & $rose(ready);
    // endsequence

    // sequence s_vector_ready;
    //     (mode == 1) & $rose(ready);
    // endsequence

    // sequence s_check_rotate
    //     check_rotation_values(angle, in_x, out_x, out_y);
    // endsequence

    // property p_check_rotate;
    //     $(posedge clk) s_rotate_ready |-> s_check_rotate;
    // endproperty
    
endmodule  // cordic_tb
