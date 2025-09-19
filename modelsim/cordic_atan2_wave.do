onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cordic_atan2_tb/clk
add wave -noupdate /cordic_atan2_tb/reset
add wave -noupdate /cordic_atan2_tb/start
add wave -noupdate /cordic_atan2_tb/x
add wave -noupdate /cordic_atan2_tb/y
add wave -noupdate /cordic_atan2_tb/ready
add wave -noupdate /cordic_atan2_tb/done
add wave -noupdate /cordic_atan2_tb/angle
add wave -noupdate -radix decimal /cordic_atan2_tb/dut/cordic_module/out_angle
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38175 ps} 0}
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
WaveRestoreZoom {0 ps} {55808 ps}
