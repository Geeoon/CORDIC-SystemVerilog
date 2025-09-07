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

Script to generate SystemVerilog and/or MIF files for CORDIC

positional arguments:
  bit_width             the bit width of the numbers (e.g., angle and out_x/out_y)

options:
  -h, --help            show this help message and exit
  -p PATH, --path PATH  the path of the output file(s)
  -s, --standalone      only generate the CORDIC core module. also sets the bit width to be the bit width for the cordic module
  -i, --pipelined       enables pipelining for the CORDIC core modules
  ```

This will generate the .sv files.

If you just want to the pregenerated modules, they are located in coric_generated.  The cordic module has a bit width of 30 and the trig modules have bit widths of 32.

## Running Tests
The testbenches for the cordic, sine, and cosine modules are located in `tests`.

Has not been tested on hardware.

## TODOs
* Calculate timing
* Test on hardware
