onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /decode_tb/clk
add wave -noupdate /decode_tb/reset
add wave -noupdate /decode_tb/instrD
add wave -noupdate /decode_tb/PCPlus4D
add wave -noupdate /decode_tb/WriteRegW
add wave -noupdate /decode_tb/WE3
add wave -noupdate /decode_tb/ResultW
add wave -noupdate /decode_tb/RD1E
add wave -noupdate /decode_tb/RD2E
add wave -noupdate /decode_tb/RegWriteE
add wave -noupdate /decode_tb/MemtoRegE
add wave -noupdate /decode_tb/MemWriteE
add wave -noupdate /decode_tb/BranchE
add wave -noupdate /decode_tb/ALUControlE
add wave -noupdate /decode_tb/ALUSrcE
add wave -noupdate /decode_tb/RegDstE
add wave -noupdate /decode_tb/JumpD
add wave -noupdate /decode_tb/PCJumpD
add wave -noupdate /decode_tb/RtE
add wave -noupdate /decode_tb/RdE
add wave -noupdate /decode_tb/SignImmE
add wave -noupdate /decode_tb/PCPlus4E
add wave -noupdate /decode_tb/errors
add wave -noupdate /decode_tb/dut/register_file_0/registers
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11216 ps} 0}
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
WaveRestoreZoom {0 ps} {100800 ps}
