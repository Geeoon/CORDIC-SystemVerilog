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

precomputed_K = math.floor(2**args.bit_width / compute_K(args.bit_width))  # floor because overestimating will result in overflows
log_2_bits = math.ceil(math.log2(args.bit_width))

args.path.mkdir(parents=True, exist_ok=True)
output_cordic_filepath = args.path / "cordic.sv"
output_cordic_data_filepath = args.path / "cordic_data.sv"
output_cordic_ctrl_filepath = args.path / "cordic_ctrl.sv"

input_cordic_filepath = pathlib.Path().cwd() / "../cordic_base/cordic.sv"
input_cordic_data_filepath = pathlib.Path().cwd() / "../cordic_base/cordic_data.sv"
input_cordic_ctrl_filepath = pathlib.Path().cwd() / "../cordic_base/cordic_ctrl.sv"

cordic_module: str = None
cordic_data_module: str = None
cordic_ctrl_module: str = None

with input_cordic_filepath.open("r", encoding="utf-8") as file:
    cordic_module = file.read()

with input_cordic_data_filepath.open("r", encoding="utf-8") as file:
    cordic_data_module = file.read()

with input_cordic_ctrl_filepath.open("r", encoding="utf-8") as file:
    cordic_ctrl_module = file.read()

with output_cordic_filepath.open("w", encoding="utf-8") as file:
    file.write(cordic_module.format(args.bit_width, log_2_bits, f"{args.bit_width}'d{precomputed_K}"))

with output_cordic_data_filepath.open("w", encoding="utf-8") as file:
    file.write(cordic_data_module)

with output_cordic_ctrl_filepath.open("w", encoding="utf-8") as file:
    file.write(cordic_ctrl_module)
