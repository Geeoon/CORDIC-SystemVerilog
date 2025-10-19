package cordic_tb_helper;
    localparam real K = 0.6072529350088812561694;
    localparam real PI = 3.14159265359;
    
    function bit check_rotation_values(real angle, real magnitude, real x, real y);
        return  almost_equal(magnitude * $cos(angle), x * K) &
                almost_equal(magnitude * $sin(angle), y * K);
    endfunction

    function bit check_vectorizing_values(real out_x, real out_angle, real in_x, real in_y);
        return  almost_equal(out_x * K, $sqrt(in_x**2 + in_y**2)) &
                almost_equal(out_angle, $atan2(in_y, in_x), .EPSILON(0.0005));
    endfunction

    function real abs(real value);
        if (value > 0) begin
            return value;
        end else begin
            return -value;
        end
    endfunction

    function bit almost_equal(real value1, real value2, real EPSILON=10000);
        $display("%f  -  %f  -  %f", value1, value2, EPSILON);
        return abs(value1 - value2) <= EPSILON;
    endfunction

    class cordic_tester #(
        parameter WIDTH=64
    );
        /**
         * @brief converts a data bus representing an angle to radians
         * @param angle the angle to convert 
         * @return \p angle in radians
         */
        static function real angle_to_rad(
            logic signed [WIDTH-1:0] angle
        );
            return (PI / 2.0) * (real'(angle) / 2.0**(WIDTH-1));
        endfunction

        /**
         * @brief randomizes the bits in a register
         * @param in the register to randomize
         * @post \p in has random bits
         */
        static function void randomize_bits(ref logic signed [WIDTH-1:0] in);
            for (int i = 0; i < WIDTH; i++) begin
                in[i] = $random;
            end
        endfunction

        /**
         * @brief test the output of a cordic rotation
         * @param in_x the x input
         * @param in_y the y input
         * @param in_angle the input angle
         * @param out_x the output x
         * @param out_y the output y
         * @return 1 if the test passed. 0 otherwise
         * @todo check rotation of vector with y component
         */
        static function bit test_rotation(
            logic signed [WIDTH-1:0] in_x,
            logic signed [WIDTH-1:0] in_y,
            logic signed [WIDTH-1:0] in_angle,
            logic signed [WIDTH-1:0] out_x,
            logic signed [WIDTH-1:0] out_y
        );
            return check_rotation_values(angle_to_rad(in_angle), in_x, out_x, out_y);
        endfunction  // test_rotation

        /**
         * @brief test the output of cordic when vectoring
         * @param in_x the x input
         * @param in_y the y input
         * @param out_angle the output angle
         * @param out_x the output x
         * @return 1 if the test passed. 0 otherwise
         */
        static function bit test_vectoring(
            logic signed [WIDTH-1:0] in_x,
            logic signed [WIDTH-1:0] in_y,
            logic signed [WIDTH-1:0] out_angle,
            logic signed [WIDTH-1:0] out_x
        );
            return check_vectorizing_values(out_x, angle_to_rad(out_angle), in_x, in_y);
        endfunction
    endclass  // cordic_tester

endpackage  // cordic_tb_helper
