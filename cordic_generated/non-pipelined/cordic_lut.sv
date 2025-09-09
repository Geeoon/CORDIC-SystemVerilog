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
            0: value=32'd1073741824;
            1: value=32'd633866811;
            2: value=32'd334917815;
            3: value=32'd170009512;
            4: value=32'd85334662;
            5: value=32'd42708931;
            6: value=32'd21359677;
            7: value=32'd10680490;
            8: value=32'd5340327;
            9: value=32'd2670173;
            10: value=32'd1335088;
            11: value=32'd667544;
            12: value=32'd333772;
            13: value=32'd166886;
            14: value=32'd83443;
            15: value=32'd41722;
            16: value=32'd20861;
            17: value=32'd10430;
            18: value=32'd5215;
            19: value=32'd2608;
            20: value=32'd1304;
            21: value=32'd652;
            22: value=32'd326;
            23: value=32'd163;
            24: value=32'd81;
            25: value=32'd41;
            26: value=32'd20;
            27: value=32'd10;
            28: value=32'd5;
            29: value=32'd3;
            30: value=32'd1;
            31: value=32'd1;
            default: value=32'bx;
        endcase
    end  // always_comb
endmodule  // cordic_data
