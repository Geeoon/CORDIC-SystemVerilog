onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cordic_sine_tb/clk
add wave -noupdate /cordic_sine_tb/reset
add wave -noupdate -radix unsigned -childformat {{{/cordic_sine_tb/angle[31]} -radix unsigned} {{/cordic_sine_tb/angle[30]} -radix unsigned} {{/cordic_sine_tb/angle[29]} -radix unsigned} {{/cordic_sine_tb/angle[28]} -radix unsigned} {{/cordic_sine_tb/angle[27]} -radix unsigned} {{/cordic_sine_tb/angle[26]} -radix unsigned} {{/cordic_sine_tb/angle[25]} -radix unsigned} {{/cordic_sine_tb/angle[24]} -radix unsigned} {{/cordic_sine_tb/angle[23]} -radix unsigned} {{/cordic_sine_tb/angle[22]} -radix unsigned} {{/cordic_sine_tb/angle[21]} -radix unsigned} {{/cordic_sine_tb/angle[20]} -radix unsigned} {{/cordic_sine_tb/angle[19]} -radix unsigned} {{/cordic_sine_tb/angle[18]} -radix unsigned} {{/cordic_sine_tb/angle[17]} -radix unsigned} {{/cordic_sine_tb/angle[16]} -radix unsigned} {{/cordic_sine_tb/angle[15]} -radix unsigned} {{/cordic_sine_tb/angle[14]} -radix unsigned} {{/cordic_sine_tb/angle[13]} -radix unsigned} {{/cordic_sine_tb/angle[12]} -radix unsigned} {{/cordic_sine_tb/angle[11]} -radix unsigned} {{/cordic_sine_tb/angle[10]} -radix unsigned} {{/cordic_sine_tb/angle[9]} -radix unsigned} {{/cordic_sine_tb/angle[8]} -radix unsigned} {{/cordic_sine_tb/angle[7]} -radix unsigned} {{/cordic_sine_tb/angle[6]} -radix unsigned} {{/cordic_sine_tb/angle[5]} -radix unsigned} {{/cordic_sine_tb/angle[4]} -radix unsigned} {{/cordic_sine_tb/angle[3]} -radix unsigned} {{/cordic_sine_tb/angle[2]} -radix unsigned} {{/cordic_sine_tb/angle[1]} -radix unsigned} {{/cordic_sine_tb/angle[0]} -radix unsigned}} -subitemconfig {{/cordic_sine_tb/angle[31]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[30]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[29]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[28]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[27]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[26]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[25]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[24]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[23]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[22]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[21]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[20]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[19]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[18]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[17]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[16]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[15]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[14]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[13]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[12]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[11]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[10]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[9]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[8]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[7]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[6]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[5]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[4]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[3]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[2]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[1]} {-height 15 -radix unsigned} {/cordic_sine_tb/angle[0]} {-height 15 -radix unsigned}} /cordic_sine_tb/angle
add wave -noupdate /cordic_sine_tb/start
add wave -noupdate /cordic_sine_tb/done
add wave -noupdate -radix decimal /cordic_sine_tb/value
add wave -noupdate -radix unsigned /cordic_sine_tb/dut/cordic_module/angle
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {18008 ps}
