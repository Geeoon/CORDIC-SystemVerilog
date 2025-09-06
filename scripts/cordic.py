import math
import argparse
import pathlib

parser = argparse.ArgumentParser(description='Script to generate SystemVerilog and/or MIF files for CORDIC')
parser.add_argument('-p', '--path', type=pathlib.Path, default=pathlib.Path.cwd(), required=False, help='the path of the output file(s)')
parser.add_argument('-s', '--standalone', action='store_true', default=False, required=False, help='only generate the CORDIC core module. ' \
                                                                                                    'also sets the bit width to be the ' \
                                                                                                    'bit width for the cordic module')
parser.add_argument('bit_width', type=int, help='the bit width of the numbers (e.g., angle and out_x/out_y)')
args = parser.parse_args()

assert(args.bit_width >= 2)  # otherwise HDL will be messed up 

def compute_K(n: int) -> float:
    """
    @brief computes the constant K
    @param n the bit width/# ofiterations
    @return the constant K
    """
    k = 1.0
    for i in range(n):
        k *= 1.0 / math.sqrt(1 + 2 ** (-2 * i))
    return k

def calculate_steps(n: int) -> list[int]:
    """
    @brief computes the step values
    @param n the bit width/# ofiterations
    @return the step values
    """
    out: list[int] = []
    for i in range(n):
        out.append(round(math.atan2(1, 2**i) * 2**(n+1) / math.pi))
    return out

def convert_steps_to_lut(steps: list[int], n: int) -> str:
    """
    @brief converts a list of steps to a LUT
    @param steps a list of steps to convert
    @return the SystemVerilog LUT as combinational logic
    """
    out = ""
    for i, step in enumerate(steps):
        out += f"            {i}: value={n}'d{step};\n"
    out += f"            default: value={n}'bx;"
    return out

if not args.standalone:
    args.bit_width -= 2
precomputed_K = math.floor((2**args.bit_width) * compute_K(args.bit_width))
log_2_bits = math.ceil(math.log2(args.bit_width))

args.path.mkdir(parents=True, exist_ok=True)
output_cordic_filepath = args.path / "cordic.sv"
output_cordic_data_filepath = args.path / "cordic_data.sv"
output_cordic_ctrl_filepath = args.path / "cordic_ctrl.sv"
output_cordic_lut_filepath = args.path / "cordic_lut.sv"

input_cordic_filepath = pathlib.Path().cwd() / "../cordic_base/cordic.sv"
input_cordic_data_filepath = pathlib.Path().cwd() / "../cordic_base/cordic_data.sv"
input_cordic_ctrl_filepath = pathlib.Path().cwd() / "../cordic_base/cordic_ctrl.sv"
input_cordic_lut_filepath = pathlib.Path().cwd() / "../cordic_base/cordic_lut.sv"

cordic_module: str = None
cordic_data_module: str = None
cordic_ctrl_module: str = None
cordic_lut_module: str = None

with input_cordic_filepath.open("r", encoding="utf-8") as file:
    cordic_module = file.read()

with input_cordic_data_filepath.open("r", encoding="utf-8") as file:
    cordic_data_module = file.read()

with input_cordic_ctrl_filepath.open("r", encoding="utf-8") as file:
    cordic_ctrl_module = file.read()

with input_cordic_lut_filepath.open("r", encoding="utf-8") as file:
    cordic_lut_module = file.read()


with output_cordic_filepath.open("w", encoding="utf-8") as file:
    file.write(cordic_module.format(args.bit_width, log_2_bits, f"{args.bit_width+1}'sd{precomputed_K}"))

with output_cordic_data_filepath.open("w", encoding="utf-8") as file:
    file.write(cordic_data_module)

with output_cordic_ctrl_filepath.open("w", encoding="utf-8") as file:
    file.write(cordic_ctrl_module)

with output_cordic_lut_filepath.open("w", encoding="utf-8") as file:
    file.write(cordic_lut_module.format(convert_steps_to_lut(calculate_steps(args.bit_width), args.bit_width)))


if not args.standalone:
    args.bit_width += 2

    output_cordic_sine_filepath = args.path / "cordic_sine.sv"
    output_cordic_cosine_filepath = args.path / "cordic_cosine.sv"

    input_cordic_sine_filepath = pathlib.Path().cwd() / "../cordic_base/cordic_sine.sv"
    input_cordic_cosine_filepath = pathlib.Path().cwd() / "../cordic_base/cordic_cosine.sv"

    cordic_sine_module: str = None
    cordic_cosine_module: str = None

    with input_cordic_sine_filepath.open("r", encoding="utf-8") as file:
        cordic_sine_module = file.read()

    with input_cordic_cosine_filepath.open("r", encoding="utf-8") as file:
        cordic_cosine_module = file.read()


    with output_cordic_sine_filepath.open("w", encoding="utf-8") as file:
        file.write(cordic_sine_module.format(args.bit_width, log_2_bits, f"{args.bit_width-1}'sd{precomputed_K}"))

    with output_cordic_cosine_filepath.open("w", encoding="utf-8") as file:
        file.write(cordic_cosine_module.format(args.bit_width, log_2_bits, f"{args.bit_width-1}'sd{precomputed_K}"))
