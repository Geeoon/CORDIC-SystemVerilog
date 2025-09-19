# CORDIC Implementation for SystemVerilog
This project implements various functions using CORDIC for SystemVerilog:
* Sine
* Cosine

## Features
* Generation script for custom input and output bit widths
* Pipelined and non-pipelined versions
  * Pipelined is good for high throughput
  * Non-pipelined is good for low resource usage
  * Both have the same latency

## Usage
Run the `cordic.py` script in `scripts`.
```
usage: cordic.py [-h] [-p PATH] [-s] [-i] bit_width

Script to generate a CORDIC implementation in SystemVerilog

positional arguments:
  bit_width             the bit width of the numbers (e.g., angle and out_x/out_y)

options:
  -h, --help            show this help message and exit
  -p PATH, --path PATH  the path of the output file(s)
  -s, --standalone      only generate the CORDIC core module
  -i, --pipelined       enables pipelining for the CORDIC core modules
  ```

This will generate the .sv files.

Pre-generated 32-bit CORDIC modules are in the `cordic_generated` directory.

## Running Tests
The testbenches for the cordic, sine, and cosine modules are located in `tests`.

Has not been tested on hardware.

## TODOs
* calculate timing in Quartus
* test on hardware (DE1-SoC)
* Custom number of iterations (currently equals bit width)
* polar to Cartesian
* division
* hyperbolic?
