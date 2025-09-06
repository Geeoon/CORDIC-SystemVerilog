/**
 * @file cordic_lut.sv
 * @author Geeoon Chung
 * @brief implements CORDIC step LUT
 */

module cordic_lut
    #(parameter BIT_WIDTH,
      parameter INPUT_WIDTH)
    (index, value);
    /**
     * @brief A CORDIC step LUT
     * @input   index the index for the lookup
     * @output  the output of the lookup
     */
    input logic [INPUT_WIDTH-1:0] index;

    output logic [BIT_WIDTH-1:0] value;

    always_comb begin
        case (index)
            0: value=32'd2147483648;
            1: value=32'd1267733622;
            2: value=32'd669835629;
            3: value=32'd340019024;
            4: value=32'd170669324;
            5: value=32'd85417861;
            6: value=32'd42719353;
            7: value=32'd21360980;
            8: value=32'd10680653;
            9: value=32'd5340347;
            10: value=32'd2670176;
            11: value=32'd1335088;
            12: value=32'd667544;
            13: value=32'd333772;
            14: value=32'd166886;
            15: value=32'd83443;
            16: value=32'd41722;
            17: value=32'd20861;
            18: value=32'd10430;
            19: value=32'd5215;
            20: value=32'd2608;
            21: value=32'd1304;
            22: value=32'd652;
            23: value=32'd326;
            24: value=32'd163;
            25: value=32'd81;
            26: value=32'd41;
            27: value=32'd20;
            28: value=32'd10;
            29: value=32'd5;
            30: value=32'd3;
            31: value=32'd1;
            default: value=32'bx;
        endcase
    end  // always_comb
endmodule  // cordic_data
