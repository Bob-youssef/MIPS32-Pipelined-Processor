onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /control_unit_tb/Op
add wave -noupdate -radix binary /control_unit_tb/Funct
add wave -noupdate /control_unit_tb/RegWriteD
add wave -noupdate /control_unit_tb/MemtoRegD
add wave -noupdate /control_unit_tb/MemWriteD
add wave -noupdate /control_unit_tb/BranchD
add wave -noupdate -radix binary /control_unit_tb/ALUControlD
add wave -noupdate /control_unit_tb/ALUSrcD
add wave -noupdate /control_unit_tb/RegDstD
add wave -noupdate /control_unit_tb/JumpD
add wave -noupdate /control_unit_tb/ZeroExtD
add wave -noupdate -radix binary /control_unit_tb/actual
add wave -noupdate -radix binary /control_unit_tb/passed
add wave -noupdate -radix binary /control_unit_tb/failed
add wave -noupdate -divider debug
add wave -noupdate -radix binary /control_unit_tb/dut/control_signals
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9863 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {10500 ps}
