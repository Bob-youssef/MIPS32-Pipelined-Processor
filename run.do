if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vlog rtl/control_unit.v
vlog rtl/register_file.v
vlog rtl/sign_extend.v

vlog rtl/decode.v
vlog tb/decode_tb.v
vsim -voptargs=+acc work.decode_tb
# add wave *
do waves/decode_wave.do

run -all
#quit -sim