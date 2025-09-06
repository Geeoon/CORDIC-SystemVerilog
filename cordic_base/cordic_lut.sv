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
{}
        endcase
    end  // always_comb
endmodule  // cordic_data
