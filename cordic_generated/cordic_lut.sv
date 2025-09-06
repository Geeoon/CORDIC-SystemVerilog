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
            0: value=30'd536870912;
            1: value=30'd316933406;
            2: value=30'd167458907;
            3: value=30'd85004756;
            4: value=30'd42667331;
            5: value=30'd21354465;
            6: value=30'd10679838;
            7: value=30'd5340245;
            8: value=30'd2670163;
            9: value=30'd1335087;
            10: value=30'd667544;
            11: value=30'd333772;
            12: value=30'd166886;
            13: value=30'd83443;
            14: value=30'd41722;
            15: value=30'd20861;
            16: value=30'd10430;
            17: value=30'd5215;
            18: value=30'd2608;
            19: value=30'd1304;
            20: value=30'd652;
            21: value=30'd326;
            22: value=30'd163;
            23: value=30'd81;
            24: value=30'd41;
            25: value=30'd20;
            26: value=30'd10;
            27: value=30'd5;
            28: value=30'd3;
            29: value=30'd1;
            default: value=30'bx;
        endcase
    end  // always_comb
endmodule  // cordic_data
