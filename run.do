if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vlog rtl/control_unit.v
vlog tb/control_unit_tb.v
vsim -voptargs=+acc work.control_unit_tb
# add wave *
do waves/control_unit_wave.do

run -all
#quit -sim