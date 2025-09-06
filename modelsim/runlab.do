# from EE 271 taught by Scott Hauck

# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./**/*.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
# vsim -voptargs="+acc" -t 1ps -lib work cordic_tb -Lf altera_mf_ver
vsim -voptargs="+acc" -t 1ps -lib work cordic_sine_tb -Lf altera_mf_ver

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
# do cordic_wave.do
do cordic_sine_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
