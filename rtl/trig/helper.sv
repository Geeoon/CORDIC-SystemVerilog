package cordic_helper;
    function automatic int calculate_K (
        int bit_width,
        int iterations
    );
        real k = 1.0;
        for (int i = 0; i < iterations; i++) begin
            k *= 1.0 / $sqrt(1 + 2 ** (-2 * i));
        end
        return $rtoi((2**(bit_width-1)) * k * 0.99999);  // * .99999 to prevent overflows
    endfunction  // calculate_K
endpackage  // cordic
