# CORDIC Implementation for SystemVerilog
This project implements various functions using CORDIC for SystemVerilog:
* Sine
* Cosine

## Features
* Support for pipelining

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
* calculate timing
* test on hardware
* vectoring mode
* atan
* polar to Cartesian
* division
* hyperbolic?
