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
            0: value=32'd3373259426;
            1: value=32'd1991351318;
            2: value=32'd1052175346;
            3: value=32'd534100635;
            4: value=32'd268086748;
            5: value=32'd134174063;
            6: value=32'd67103403;
            7: value=32'd33553749;
            8: value=32'd16777131;
            9: value=32'd8388597;
            10: value=32'd4194303;
            11: value=32'd2097152;
            12: value=32'd1048576;
            13: value=32'd524288;
            14: value=32'd262144;
            15: value=32'd131072;
            16: value=32'd65536;
            17: value=32'd32768;
            18: value=32'd16384;
            19: value=32'd8192;
            20: value=32'd4096;
            21: value=32'd2048;
            22: value=32'd1024;
            23: value=32'd512;
            24: value=32'd256;
            25: value=32'd128;
            26: value=32'd64;
            27: value=32'd32;
            28: value=32'd16;
            29: value=32'd8;
            30: value=32'd4;
            31: value=32'd2;
            default: value=32'bx;
        endcase
    end  // always_comb
endmodule  // cordic_data
