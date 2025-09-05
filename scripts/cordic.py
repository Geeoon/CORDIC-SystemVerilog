import math
import argparse
import pathlib
import constants

parser = argparse.ArgumentParser(description='Script to generate SystemVerilog and/or MIF files for CORDIC')
parser.add_argument('--path', type=pathlib.Path, default=pathlib.Path.cwd(), required=False, help='The path of the output file(s)')
parser.add_argument('bit_width', type=int, help='The bit width of the numbers (e.g., angle and out_x/out_y)')
args = parser.parse_args()

assert(args.bit_width >= 2)  # otherwise HDL will be messed up 

def compute_K(n: int) -> float:
    """
    @brief computes the constant K
    @param in_width the width of iterations/bit width
    @return the constant K
    """
    k = 1.0
    for i in range(n):
        k *= 1.0 / math.sqrt(1 + 2 ** (-2 * i))
    return k

precomputed_K = math.floor(compute_K(args.bit_width) * 2**args.bit_width)  # floor because overestimating will result in overflows
log_2_bits = math.ceil(math.log2(args.bit_width))

args.path.mkdir(parents=True, exist_ok=True)
cordic_filepath = args.path / "cordic.sv"
cordic_data_filepath = args.path / "cordic_data.sv"
cordic_ctrl_filepath = args.path / "cordic_ctrl.sv"

with cordic_filepath.open("w", encoding="utf-8") as file:
    file.write(constants.CORDIC_MODULE.format(args.bit_width, log_2_bits, f"{args.bit_width}'d{precomputed_K}"))

with cordic_data_filepath.open("w", encoding="utf-8") as file:
    file.write(constants.CORDIC_DATA_MODULE)

with cordic_ctrl_filepath.open("w", encoding="utf-8") as file:
    file.write(constants.CORDIC_CTRL_MODULE)
