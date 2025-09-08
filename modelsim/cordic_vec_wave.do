onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cordic_vec_tb/clk
add wave -noupdate /cordic_vec_tb/reset
add wave -noupdate /cordic_vec_tb/start
add wave -noupdate -radix unsigned /cordic_vec_tb/in_x
add wave -noupdate -radix unsigned /cordic_vec_tb/in_y
add wave -noupdate /cordic_vec_tb/ready
add wave -noupdate /cordic_vec_tb/done
add wave -noupdate -radix unsigned /cordic_vec_tb/phase
add wave -noupdate -radix unsigned /cordic_vec_tb/magnitude
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16496 ps} 0}
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
