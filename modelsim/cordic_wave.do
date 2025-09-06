onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cordic_tb/clk
add wave -noupdate /cordic_tb/reset
add wave -noupdate /cordic_tb/start
add wave -noupdate /cordic_tb/done
add wave -noupdate -radix unsigned /cordic_tb/angle
add wave -noupdate -radix unsigned /cordic_tb/out_x
add wave -noupdate -radix unsigned /cordic_tb/out_y
add wave -noupdate -radix unsigned /cordic_tb/dut/datapath/target_reg
add wave -noupdate -radix decimal /cordic_tb/dut/datapath/current
add wave -noupdate /cordic_tb/dut/datapath/reached_target
add wave -noupdate /cordic_tb/dut/datapath/dir
add wave -noupdate -radix unsigned /cordic_tb/dut/datapath/diff
add wave -noupdate /cordic_tb/dut/datapath/add
add wave -noupdate /cordic_tb/dut/datapath/sub
add wave -noupdate /cordic_tb/dut/datapath/iter
add wave -noupdate -radix unsigned /cordic_tb/dut/datapath/i
add wave -noupdate /cordic_tb/dut/datapath/x_reg
add wave -noupdate /cordic_tb/dut/datapath/y_reg
add wave -noupdate /cordic_tb/dut/datapath/shifted_x
add wave -noupdate /cordic_tb/dut/datapath/shifted_y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13150 ps} 0}
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
WaveRestoreZoom {0 ps} {18533 ps}
